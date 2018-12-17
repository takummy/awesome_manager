class TasksController < ApplicationController
  before_action :set_task, only: %i(show edit update destroy)
  before_action :require_login

  def index
    @tasks = current_user.tasks.order_by_expired_at(params[:sort_expired])
                               .order_by_priority(params[:sort_priority])
    if params[:task] && params[:task][:search]
      @tasks = current_user.tasks.order_by_expired_at(params[:sort_expired])
                   .search_title(params[:task][:title_search])
                   .search_state(params[:task][:state_search])
    end
    @tasks = @tasks.page(params[:page]).per(10)
  #メソッドパターン
    # @tasks = Task.order_by_expired_at?(params[:sort_expired])
    # if params[:task] && params[:task][:search]
    #   if
    #     @tasks = Task.search_title?(params[:task][:title_search])
    #                  .search_state?(params[:task][:state_search])
    #   elsif
    #     @tasks = Task.search_title
    #   else 
    #     @tasks = Task.search_state?(params[:task][:state_search])
    #   end
    # end
  end

  def new
    @task = Task.new
    @labels = Label.all
    @task.labels.build
  end

  def create
    @task = current_user.tasks.build(task_params)

    if @task.save
      flash[:success] = "登録完了"
      redirect_to task_path(@task.id)
    else
      render :new
    end
  end

  def show
  end

  def edit
    @labels = @task.labels
  end

  def update
    if @task.update(task_params)
      flash[:success] = "編集しました"
      redirect_to task_path(@task.id)
    else
      render :edit
    end
  end

  def destroy
    @task.destroy
    flash[:success] = "削除しました "
    redirect_to tasks_path 
  end

  private
  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(
      :title,
      :content,
      :expired_at,
      :state,
      :priority,
      label_ids: [],
      labels_attributes: %i(id name)
    )
  end
end
