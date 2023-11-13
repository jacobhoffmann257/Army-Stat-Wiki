class TagProfilesController < ApplicationController
  before_action :set_tag_profile, only: %i[ show edit update destroy ]

  # GET /tag_profiles or /tag_profiles.json
  def index
    @tag_profiles = TagProfile.all
  end

  # GET /tag_profiles/1 or /tag_profiles/1.json
  def show
  end

  # GET /tag_profiles/new
  def new
    @tag_profile = TagProfile.new
  end

  # GET /tag_profiles/1/edit
  def edit
  end

  # POST /tag_profiles or /tag_profiles.json
  def create
    @tag_profile = TagProfile.new(tag_profile_params)

    respond_to do |format|
      if @tag_profile.save
        format.html { redirect_to tag_profile_url(@tag_profile), notice: "Tag profile was successfully created." }
        format.json { render :show, status: :created, location: @tag_profile }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @tag_profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tag_profiles/1 or /tag_profiles/1.json
  def update
    respond_to do |format|
      if @tag_profile.update(tag_profile_params)
        format.html { redirect_to tag_profile_url(@tag_profile), notice: "Tag profile was successfully updated." }
        format.json { render :show, status: :ok, location: @tag_profile }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @tag_profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tag_profiles/1 or /tag_profiles/1.json
  def destroy
    @tag_profile.destroy

    respond_to do |format|
      format.html { redirect_to tag_profiles_url, notice: "Tag profile was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tag_profile
      @tag_profile = TagProfile.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def tag_profile_params
      params.require(:tag_profile).permit(:tag_id, :profile_id)
    end
end
