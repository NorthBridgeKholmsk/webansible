class HostRolesController < ApplicationController
  add_flash_types :error
  def index
    @host_role = HostRole.new
    render "index"
  end

  def new
    @host_role = HostRole.new
  end

  def create
    @host_role = HostRole.new(role_params)
    if @host_role.save
      render "index"
    else
      flash[:error] = @host_role.errors.full_messages
      render "index"
    end
  end

  def edit
    @host_role = HostRole.find(params[:id])
    render "_edit"
  end

  def update
    @host_role = HostRole.find(params[:id])

    if @host_role.update(role_params)
      render "index"
    else
      flash[:error] = @host_role.errors.full_messages
      render "index"
    end
  end

  def destroy
    @ids = params[:id].split(',')
    flash[:error] = ""
    for id_role in @ids do
      @host_role = HostRole.find_by(id_role: id_role)
      @check = Host.where("host_role LIKE ?", @host_role.id)
      if @check.size == 0
        @host_role.destroy
      else
        flash[:error] += "Роль хоста #{@host_role.name} содержит хосты, в количестве: #{@check.size}. Для удаления уберите хосты из роли. \n"
      end
    end
    render "index"
  end

  def show
    @ids = params[:id]
  end

  private
  def role_params
    params.require(:host_role).permit(:id_role, :name, :zabbix_code)
  end
end
