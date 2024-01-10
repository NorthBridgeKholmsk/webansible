class PlaybooksController < ApplicationController
  add_flash_types :error
  def index
    @playbook = Playbook.new
    @playbooks = Playbook.all
    render "index"
  end

  def new
    @playbook = Playbook.new
    render "new"
  end

  def create
    @playbook = Playbook.new(playbook_params)
    if @playbook.save
      render "index"
    else
      flash[:error] = @playbook.errors.full_messages
      render "index"
    end
  end

  def edit
    @playbook = Playbook.find(params[:id])
    render "edit"
  end

  def update
    @playbook = Playbook.find(params[:id])
    if @playbook.update(playbook_params)
      render "index"
    else
      flash[:error] = @playbook.errors.full_messages
      render "index"
    end
  end

  def show
    @playbook = Playbook.find(params[:id])
    render "index"
  end

  def destroy
    @playbook = Playbook.find(params[:id])
    @playbook.destroy
    render "index"
  end

  private
  def playbook_params
    params.require(:playbook).permit(:name, :comment, :lin_tasks, :win_tasks)
  end
end
