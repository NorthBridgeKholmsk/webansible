class ApplicationController < ActionController::Base
  before_action :read_config

  def authenticate_user
    if session[:user_id]
      @current_user = User.find(session[:user_id])
      return true
    else
      redirect_to("/")
      return false
    end
  end
  def save_login_state
    if session[:user_id]
      redirect_to("/home")
      return false
    else
      return true
    end
  end

  private
  def read_config
    config = "./config/webansible.conf"
    vars = {"work_dir" => "/home/ansible", "port" => "3000"}
    if File.file? config
      File.open(config, "r") do |f|
        f.each_line do |line|
          var = line.split('=')
          if var[1][-2] == "/"
            var[1].chomp!
            var[1].chop!
          else
            var[1].chomp!
          end
          vars[var[0]] = var[1]
        end
      end
    else
      f = File.new(config, "a:UTF-8")
      vars.each do |key,value|
        f.print(key + "=" + value + "\n")
      end
      f.close
    end
    @work_dir = vars["work_dir"]
    unless Dir.exist?(@work_dir)
      FileUtils.mkdir_p(@work_dir)
    end
    @port = vars["port"]
  end
end
