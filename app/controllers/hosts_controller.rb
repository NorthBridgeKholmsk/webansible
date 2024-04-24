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

  end

  private
  def host_params
    params.require(:host).permit(:hostname, :address, :login, :password, :host_type_id, :os, :group_id, :host_role=>[])
  end
end
