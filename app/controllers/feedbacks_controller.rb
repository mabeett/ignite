class FeedbacksController < ApplicationController
  before_filter :require_local, only: [:index, :edit, :update, :destroy]
  hide_action :default_args, :find_feedback
  
  layout ->(controller) { controller.request.xhr? ? false : 'application' }
  
  # GET /feedbacks
  # GET /feedbacks.json
  def index
    @title = t('view.feedbacks.index_title')
    @feedbacks = Feedback.page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @feedbacks }
    end
  end

  # GET /feedbacks/1
  # GET /feedbacks/1.json
  def show
    @title = t('view.feedbacks.show_title')
    @feedback = find_feedback

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @feedback }
    end
  end

  # GET /feedbacks/new
  # GET /feedbacks/new.json
  def new
    @title = t('view.feedbacks.new_title')
    @feedback = Feedback.new(default_args)

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @feedback }
    end
  end

  # GET /feedbacks/1/edit
  def edit
    @title = t('view.feedbacks.edit_title')
    @feedback = find_feedback
  end

  # POST /feedbacks
  # POST /feedbacks.json
  def create
    @title = t('view.feedbacks.new_title')
    @feedback = Feedback.new(default_args.reverse_merge(params[:feedback]))

    respond_to do |format|
      if @feedback.save
        format.html { redirect_to @feedback, notice: t('view.feedbacks.correctly_created') }
        format.json { render json: @feedback, status: :created, location: @feedback }
      else
        format.html { render action: 'new' }
        format.json { render json: @feedback.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /feedbacks/1
  # PUT /feedbacks/1.json
  def update
    @title = t('view.feedbacks.edit_title')
    @feedback = find_feedback

    respond_to do |format|
      if @feedback.update_attributes(default_args.reverse_merge(params[:feedback]))
        format.html { redirect_to @feedback, notice: t('view.feedbacks.correctly_updated') }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @feedback.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # DELETE /feedbacks/1.json
  def destroy
    @feedback = find_feedback
    @feedback.destroy

    respond_to do |format|
      format.html { redirect_to feedbacks_url }
      format.json { head :ok }
    end
  end
  
  private
  
  def default_args
    { ip: request.remote_ip }
  end
  
  def find_feedback
    local? ?
      Feedback.find(params[:id]) :
      Feedback.find_by_id_and_ip(params[:id], request.remote_ip)
  end
end
