class HostTypesController < ApplicationController
  def index
    @host_type = HostType.new
    render "index"
  end

  def new
    @host_type = HostType.new
  end

  def create
    @host_type = HostType.new(type_params)
    if @host_type.save
      render "index"
    else
      flash[:error] = @host_type.errors.full_messages
      render "index"
    end
  end

  def edit
    @host_type = HostType.find(params[:id])
    render "_edit"
  end

  def update
    @host_type = HostType.find(params[:id])

    if @host_type.update(type_params)
      render "index"
    else
      flash[:error] = @host_type.errors.full_messages
      render "index"
    end
  end

  def destroy
    @ids = params[:id].split(',')
    flash[:error] = ""
    for id_type in @ids do
      @host_type = HostType.find_by(id_type: id_type)
      @check = Host.where("host_type_id LIKE ?", @host_type.id)
      if @check.size == 0
        @host_type.destroy
      else
        flash[:error] += "Тип хоста #{@host_type.name} содержит хосты, в количестве: #{@check.size}. Для удаления уберите хосты из типа. \n"
      end
    end
    render "index"
  end

  def show
    @ids = params[:id]
  end

  private
  def type_params
    params.require(:host_type).permit(:id_type, :name)
  end
end
