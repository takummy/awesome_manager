class TasksController < ApplicationController
  before_action :set_task, only: %i(show edit update destroy)
  before_action :set_labels, only: %i(index new edit)
  before_action :require_login

  def index
    @tasks = current_user.tasks.order_by_expired_at(params[:sort_expired])
                               .order_by_priority(params[:sort_priority])
    if params[:task] && params[:task][:search]
      task_search(params[:sort_expired],
                  params[:task][:title_search],
                  params[:task][:state_search],
                  params[:task][:label_search])
    # リファクタする前
    # @tasks = current_user.tasks.order_by_expired_at(params[:sort_expired])
    #                            .search_title(params[:task][:title_search])
    #                            .search_state(params[:task][:state_search])
    #                            .search_label(params[:task][:label_search])
    end
    @tasks = @tasks.page(params[:page]).per(10)
  #メソッドで書くパターン
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

  def set_labels
    @labels = Label.all
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


  def task_search(sort_expired, title_search, state_search, label_search)
    @tasks = current_user.tasks.order_by_expired_at(sort_expired)
    @tasks = @tasks.search_title(title_search)
    @tasks = @tasks.search_state(state_search)
    @tasks = @tasks.search_label(label_search)
  end
end
