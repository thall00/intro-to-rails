class TopicsController < ApplicationController
  before_action :set_topic, only: [:show, :edit, :update, :destroy]

  # GET /topics
  # GET /topics.json
  # THIS IS WHERE TO SORT:
  def index
    @vote_count_hash = Vote.group(:topic_id).count    # => { 'id_abc' => 5, 'id_xyz' => 3 }
    @topics = Topic.all.sort_by { |topic| @vote_count_hash[topic.id]}
  end

  # GET /topics/1
  # GET /topics/1.json
  def show
  end


  # GET /topics/new
  def new
    @topic = Topic.new
  end

  # GET /topics/about
  def about
  end

  # GET /topics/1/edit
  def edit
  end

  # POST /topics
  # POST /topics.json
  def create
    @topic = Topic.new(topic_params)

    respond_to do |format|
      if @topic.save
        format.html { redirect_to topics_path, notice: 'Topic was successfully created.' }
        format.json { render :show, status: :created, location: @topic }
      else
        format.html { render :new }
        format.json { render json: @topic.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /topics/1
  # PATCH/PUT /topics/1.json
  def update
    respond_to do |format|
      if @topic.update(topic_params)
        format.html { redirect_to topics_path, notice: 'Topic was successfully updated.' }
        format.json { render :show, status: :ok, location: @topic }
      else
        format.html { render :edit }
        format.json { render json: @topic.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /topics/1
  # DELETE /topics/1.json
  def destroy
    @topic.destroy
    respond_to do |format|
      format.html { redirect_to topics_url, notice: 'Topic was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  def upvote
    @topic = Topic.find(params[:id])
    @topic.votes.create
    redirect_to(topics_path)
  end

  def downvote
    @topic = Topic.find(params[:id])
    if @topic.votes.count > 0
      @topic.votes.last.destroy
    end
    redirect_to(topics_path)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_topic
      @topic = Topic.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def topic_params
      params.require(:topic).permit(:title, :description)
    end
end
