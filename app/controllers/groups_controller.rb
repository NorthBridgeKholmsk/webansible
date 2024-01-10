class GroupsController < ApplicationController
  add_flash_types :error
  def index
    @group = Group.new
    render "index"
  end

  def new
    @group = Group.new
  end

  def show
    @ids = params[:id]
  end

  def create
    @group = Group.new(group_params)
    if @group.save
      render "index"
    else
      flash[:error] = @group.errors.full_messages
      render "index"
    end
  end

  def edit
    @group = Group.find(params[:id])
    render "_edit"
  end

  def update
    @group = Group.find(params[:id])

    if @group.update(group_params)
      render "index"
    else
      flash[:error] = @group.errors.full_messages
      render "index"
    end
  end

  def destroy
    @ids = params[:id].split(',')
    flash[:error] = ""
    for name in @ids do
      @group = Group.find_by(name: name)
      @check = Host.where("group_id LIKE ?", @group.id)
      if @check.size == 0
        @group.destroy
      else
        flash[:error] += "Группа #{@group.name} содержит хосты, в количестве: #{@check.size}. Для удаления уберите хосты из группы. \n"
      end
    end
    render "index"
  end

  private
  def group_params
    params.require(:group).permit(:name, :variables)
  end
end
