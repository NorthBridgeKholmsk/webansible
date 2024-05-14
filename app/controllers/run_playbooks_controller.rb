class RunPlaybooksController < ApplicationController
  add_flash_types :error
  def index
    @playbooks = Playbook.all
    @hosts = Host.all
    render "index"
  end

  def run
    @playbooks = Playbook.all
    @hosts = Host.all
    if params[:playbook].to_s.empty? || params[:hosts].to_s.empty?
      flash[:error] = "Должен быть выбран плейбук и хосты, на которых он выполнится"
      render "index"
    else
      error = create_temp_inventory_file(params[:playbook], params[:hosts].split(','))
      if error.to_s.empty?
        render "output"
      else
        flash[:error] = error
        render "index"
      end
    end
  end

  def get_output
    IO.popen("ansible-playbook -i #{@work_dir+"/inventory/hosts.yml"} #{@work_dir+"/playbook/main.yml"}") do |f|
      f.each do |line|
        sleep(0.05)
        OutputChannel.broadcast_to("OutputChannel#{session[:user_id]}", line)
      end
    end
    FileUtils.remove_dir(@work_dir+"/inventory", true)
    FileUtils.remove_dir(@work_dir+"/playbook", true)
    head :ok
  end

  private

  def create_temp_inventory_file(playbook, hosts)
    groups = {}
    hosts.each do |host|
      tmphost = Host.find_by(hostname: host)
      unless tmphost.nil?
        group = Group.find(Host.find_by(hostname: host).group_id).name
        unless group.nil?
          unless groups.key?(group)
            groups[group] = []
          end
          groups[group] << host
        else
          return "В хосте #{host} указана несуществующая группа"
        end
      else
        return "Хост #{host} не существует"
      end
    end
    if Dir.exist?(@work_dir+"/inventory")
      FileUtils.remove_dir(@work_dir+"/inventory", true)
    end
    Dir.mkdir(@work_dir+"/inventory")
    f = File.new(@work_dir+"/inventory/hosts.yml", "a:UTF-8")
    f.print("all:\n")
    f.print("  children:\n")
    groups.each do |key, value|
      f.print("    " + key+":\n")
      create_temp_group_files(key)
      f.print("      hosts:\n")
      value.each do |host|
        f.print("        " + host+":\n")
        create_temp_hosts_files(host)
      end
    end
    f.close
    error = create_temp_playbook_file(playbook)
    unless error.nil?
      return error
    end
  end

  def create_temp_group_files(name)
    @group = Group.find_by(name: name)
    group_vars_dir = @work_dir+"/inventory/group_vars"
    unless Dir.exist?(group_vars_dir)
      Dir.mkdir(group_vars_dir)
    end
    f = File.new(group_vars_dir + "/#{name}.yml", "a:UTF-8")
    unless @group.variables.nil?
      @group.variables.split(',').each do |var|
        varPair = var.split(":")
        f.print("#{varPair[0]}: #{varPair[1]}\n")
      end
    end
    f.close
  end

  def create_temp_hosts_files(name)
    @host = Host.find_by(hostname: name)
    host_vars_dir = @work_dir+"/inventory/host_vars"
    unless Dir.exist?(host_vars_dir)
      Dir.mkdir(host_vars_dir)
    end
    f = File.new(host_vars_dir + "/#{name}.yml", "a:UTF-8")
    f.print("ansible_host: #{@host.address}\n")
    f.print("ansible_user: #{@host.login}\n")
    f.print("ansible_password: #{@host.password}")
    f.close
  end

  def create_temp_playbook_file(name)
    playbook = Playbook.find_by(name: name)
    unless playbook.nil?
      playbook_dir = @work_dir+"/playbook"
      if Dir.exist?(playbook_dir)
        FileUtils.remove_dir(playbook_dir, true)
      end
      Dir.mkdir(playbook_dir)
      f = File.new(playbook_dir + "/main.yml", "a:UTF-8")
      f.print("---\n")
      f.print("- hosts: all\n")
      f.print("  tasks:\n")
      unless playbook.lin_tasks.to_s.empty?
        f.print("  - include_tasks: ./linux/main.yml\n")
        f.print("    when: ansible_facts['os_family'] == \"Debian\"\n")
        Dir.mkdir(playbook_dir+"/linux")
        fl = File.new(playbook_dir + "/linux/main.yml", "a:UTF-8")
        fl.print(playbook.lin_tasks)
        fl.close
      end
      unless playbook.win_tasks.to_s.empty?
        f.print("  - include_tasks: ./windows/main.yml\n")
        f.print("    when: ansible_facts['os_family'] == \"Windows\"\n")
        Dir.mkdir(playbook_dir+"/windows")
        fl = File.new(playbook_dir + "/windows/main.yml", "a:UTF-8")
        fl.print(playbook.win_tasks)
        fl.close
      end
      f.close

    else
      return "Плейбук с именем #{name} не обнаружен"
    end
  end
end
