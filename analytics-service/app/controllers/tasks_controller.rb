class TasksController < ApplicationController
  before_action :set_task, only: %i[ show ]
  before_action :login_required

  # GET /tasks or /tasks.json
  def index
    @tasks = Task.all
  end

  # GET /tasks/1 or /tasks/1.json
  def show
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_task
    @task = Task.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def task_params
    params.require(:task).permit(:account_id, :public_id, :fee, :price, :description)
  end
end
