class TasksController < ApplicationController
  before_action :set_task, only: %i[ show edit update destroy ]
  before_action :login_required

  # GET /tasks or /tasks.json
  def index
    # if current_account
      # redirect_to new_account_session_path unless current_account.present?
      @tasks = if current_account.admin? || current_account.manager? || current_account.lead?
                 Task.all
               elsif current_account.employee?
                 Task.where(account_id: current_account.id)
               else
                 Task.none
               end
    # else
    #   redirect_to new_account_session_path
    # end
  end

  # GET /tasks/1 or /tasks/1.json
  def show
  end

  # GET /tasks/new
  def new
    @task = Task.new
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks or /tasks.json
  def create
    @task = Task.new(task_params)
    TaskManagement.create_task(@task)

    respond_to do |format|
      if @task.save
        event = {
          event_id: SecureRandom.uuid,
          event_version: 1,
          event_time: Time.now.to_s,
          producer: 'task-service',
          event_name: "TaskCreated",
          data: {
            public_id: @task.public_id,
            assignee_public_id: @task.account.public_id
          }
        }
        Karafka.producer.produce_sync(topic: 'task-workflow', payload: event.to_json)

        event = {
          event_id: SecureRandom.uuid,
          event_version: 1,
          event_time: Time.now.to_s,
          producer: 'task-service',
          event_name: "TaskCreated",
          data: {
            public_id: @task.public_id,
            created_at: @task.created_at.to_i,
            description: @task.description
          }
        }
        Karafka.producer.produce_sync(topic: 'task-streaming', payload: event.to_json)

        format.html { redirect_to task_url(@task), notice: "Task was successfully created." }
        format.json { render :show, status: :created, location: @task }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1 or /tasks/1.json
  def update
    respond_to do |format|
      @task.assign_attributes(task_params)
      TaskManagement.complete_task(@task) if @task.finished?
      if @task.save
        event = {
          event_id: SecureRandom.uuid,
          event_version: 1,
          event_time: Time.now.to_s,
          producer: 'task-service',
          event_name: "TaskCompleted",
          data: {
            public_id: @task.public_id,
            last_assignee_public_id: @task.account.public_id,
            completed_at: @task.finished_at.to_i
          }
        }
        Karafka.producer.produce_sync(topic: 'task-workflow', payload: event.to_json)

        format.html { redirect_to task_url(@task), notice: "Task was successfully updated." }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1 or /tasks/1.json
  def destroy
    @task.destroy!

    respond_to do |format|
      format.html { redirect_to tasks_url, notice: "Task was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def reassign_tasks
    TaskManagement.reassign_tasks

    respond_to do |format|
      format.html { redirect_to tasks_url, notice: "Tasks were successfully reassigned." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def task_params
      params.require(:task).permit(:description, :status, :finished_at, :account_id)
    end
end
