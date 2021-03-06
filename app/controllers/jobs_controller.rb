class JobsController < ApplicationController
  before_action :find_job, only: [:show, :edit, :update, :destroy]


  def index
    if params[:category].blank?
      #@jobs = Job.all.order('created_at DESC')
      #@jobs = Job.where(user_id: current_user)// needs a job-user association
      @jobs = Job.all.paginate(:page => params[:page], :per_page => 2)
    else
      @category_id = Category.find_by(name: params[:category]).id
      @jobs = Job.where(category_id: @category_id).order('created_at DESC').paginate(:page => params[:page], :per_page => 2)
    end
  end


  def new
    @job = Job.new
  end

  def create
    @job = Job.new(jobs_params)
    if @job.save
      redirect_to jobs_path
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @job.update(jobs_params)
      redirect_to @job
    else
      render 'edit'
    end
  end

  def destroy
      @job.destroy
      redirect_to root_path
  end


  private
  def jobs_params
    params.require(:job).permit(:title,:description,:company,:url,:category_id)
  end
  def find_job
    @job = Job.find(params[:id])
  end
end
