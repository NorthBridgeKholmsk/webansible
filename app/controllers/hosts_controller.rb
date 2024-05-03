class HostsController < ApplicationController
  @@hosts_search = Host.all
  add_flash_types :error
  def index
    @host = Host.new
    @hosts = Host.all
    render "index"
  end

  def search
    params[:host][:hostname] = "%" if params[:host][:hostname].empty?
    params[:host][:address] = "%" if params[:host][:address].empty?
    params[:host][:host_type].empty? ? params[:host][:host_type] = "%" : params[:host][:host_type] = HostType.find_by(name: params[:host][:host_type])
    params[:host][:os] = "%" if params[:host][:os].empty?
    params[:host][:host_role].empty? ? params[:host][:host_role] = "%" : params[:host][:host_role] = "%" + HostRole.find_by(name: params[:host][:host_role]).id.to_s + "%"
    params[:host][:group].empty? ? params[:host][:group] = "%" : params[:host][:group] = Group.find_by(name: params[:host][:group])

    @hosts = Host.where("hostname LIKE ? AND address LIKE ? AND host_type_id LIKE ? AND os LIKE ? AND host_role LIKE ? AND group_id LIKE ?",
                        params[:host][:hostname], params[:host][:address], params[:host][:host_type], params[:host][:os], params[:host][:host_role], params[:host][:group])
    @@hosts_search = @hosts
    render "index"
  end

  def new
    @host = Host.new
  end

  def show
    @ids = params[:id]
  end

  def create
    @hosts = Host.all
    @host_params_arr = host_params
    @host_params_arr[:host_role] = @host_params_arr[:host_role][1..-1].join(",")
    @host = Host.new(@host_params_arr)
    if @host.save
      @hosts = @@hosts_search
      render "index"
    else
      flash[:error] = @host.errors.full_messages
      render "index"
    end
  end

  def edit
    @host = Host.find(params[:id])
    render "_edit"
  end

  def update
    @host = Host.find(params[:id])
    @hosts = @@hosts_search
    @host_params_arr = host_params
    @host_params_arr[:host_role] = @host_params_arr[:host_role][1..-1].join(",")
    if @host_params_arr[:password] == ""
      @host_params_arr[:password] = @host.password
    end
    if @host.update(@host_params_arr)
      render "index"
    else
      flash[:error] = @host.errors.full_messages
      render "index"
    end
  end

  def destroy
    @ids = params[:id].split(',')
    @hosts = @@hosts_search
    for hostname in @ids do
      @host = Host.find_by(hostname: hostname)
      @host.destroy
    end
    render "index"
  end

  def load_hosts
    groups = send_zabbix_request("hostgroup.get", {
      "output" => "extend",
      "selectHosts" => "extend",
      "filter" => {
        "name" => HostType.all.to_a.collect! {|type| type["id_type"]}
      }
    })
    hosts = JSON(groups.body)["result"]
    hosts[0]["hosts"].each do |host|
      new_host = Host.new
      hostinfo = send_zabbix_request("host.get", {
       "selectGroups" => "extend",
       "selectInterfaces" => "extend",
       "filter" => {
         "host" => [
           host["name"]
         ]
       }
     })
      new_host.hostname = host["name"]
      new_host.address = JSON(hostinfo.body)["result"][0]["interfaces"][0]["ip"].to_s
      new_host.host_type_id = HostType.find_by(id_type: (JSON(hostinfo.body)["result"][0]["groups"].collect! { |group| group["name"] } & HostType.all.to_a.collect! {|type| type["id_type"]})[0]).id.to_i
      if JSON(hostinfo.body)["result"][0]["groups"].collect! { |group| group["name"] }.include?(@zabbix_lin_group)
        new_host.os = "Linux"
      else if JSON(hostinfo.body)["result"][0]["groups"].collect! { |group| group["name"] }.include?(@zabbix_win_group)
             new_host.os = "Windows"
           end
      end
      HostRole.all.to_a.collect!{|role|
        unless (new_host.hostname.split('.')[0].split('-')[1] =~ /^#{role.zabbix_code.split(',').join('|')}[0-9]*$/) == nil
          new_host.host_role = role.id.to_s
          break
        else
          new_host.host_role = @def_role.to_s
        end
      }
      if Group.find_by(name: new_host.hostname.split('.')[1]) == nil
        group = Group.new
        group.name = new_host.hostname.split('.')[1]
        unless group.save
          next
        end
      end
      new_host.group_id = Group.find_by(name: new_host.hostname.split('.')[1]).id

      passid = ""
      token = JSON(send_passwork_request(@api_passwd, true, "/auth/login/", false, "").body)["data"]["token"]
      passes = JSON(send_passwork_request({"query" => new_host.hostname, "tags" => ["ssh"]}, false, "/passwords/search", false, token).body)["data"]
      passes.each do |pass|
        if pass["tags"].include?("admin") && pass["name"] == new_host.hostname
          passid = pass["id"]
        end
      end
      pass = JSON(send_passwork_request(passid, true, "/passwords/", true, token).body)["data"]
      new_host.login = pass["login"].to_s
      new_host.password = Base64.decode64(pass["cryptedPassword"].to_s)

      host = Host.find_by(hostname: new_host.hostname)
      unless host == nil
        unless host.update({
                             :hostname => new_host.hostname,
                             :address => new_host.address,
                             :login => new_host.login,
                             :password => new_host.password,
                             :host_type_id => new_host.host_type_id,
                             :os => new_host.os,
                             :group_id => new_host.group_id,
                             :host_role => new_host.host_role
                           })
          next
        end
      else
        unless new_host.save
          next
        end
      end
    end
    head :ok
  end

  private
  def host_params
    params.require(:host).permit(:hostname, :address, :login, :password, :host_type_id, :os, :group_id, :host_role=>[])
  end

  def send_zabbix_request(method, params)
    uri = URI.parse(@zabbix_url + "/api_jsonrpc.php")
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.request_uri)
    body = {"jsonrpc"=>"2.0","method"=>method,
            "params"=>params,
            "auth" => @api_zabbix, "id"=>1}
    request.body = body.to_json
    request["Content-Type"] = "application/json-rpc"
    response = http.request(request)
    return response
  end

  def send_passwork_request(params, paramsinurl, method, isGet, token)
    if paramsinurl
      uri = URI.parse(@passwork_url + "/api/v4" + method + params)
      body = {}
    else
      uri = URI.parse(@passwork_url + "/api/v4" + method)
      body = params
    end
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    if isGet
      request = Net::HTTP::Get.new(uri.request_uri)
    else
      request = Net::HTTP::Post.new(uri.request_uri)
    end
    request.body = body.to_json
    request["Accept"] = "application/json"
    unless token == ""
      request["Passwork-Auth"] = token
      request["Content-Type"] = "application/json"
    end
    response = http.request(request)
    return response
  end
end
