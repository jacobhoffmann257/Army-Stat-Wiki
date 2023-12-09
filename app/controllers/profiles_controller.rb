class ProfilesController < ApplicationController
  before_action :set_weapon
  before_action :set_profile, only: %i[ show edit update destroy ]
  before_action(except: [:show]){authorize(@model|| model)}
  # GET /profiles or /profiles.json
  def index
    @profiles = Profile.all
    authorize @model[0]
  end

  # GET /profiles/1 or /profiles/1.json
  def show
    authorize @model
  end

  # GET /profiles/new
  def new
    @profile = Profile.new
    authorize @model
  end

  # GET /profiles/1/edit
  def edit
    authorize @model
  end

  # POST /profiles or /profiles.json
  def create
    @profile = Profile.new(profile_params)

    respond_to do |format|
      if @profile.save
        format.html { redirect_to profile_url(@profile), notice: "Profile was successfully created." }
        format.json { render :show, status: :created, location: @profile }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /profiles/1 or /profiles/1.json
  def update
    respond_to do |format|
      if @profile.update(profile_params)
        format.html { redirect_to profile_url(@profile), notice: "Profile was successfully updated." }
        format.json { render :show, status: :ok, location: @profile }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /profiles/1 or /profiles/1.json
  def destroy
    authorize @model
    @profile.destroy

    respond_to do |format|
      format.html { redirect_to profiles_url, notice: "Profile was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_profile
      @profile = Profile.find(params[:id])
    end
    def set_weapon
      @weapon = Weapon.find(params[:weapon_id])
    end
    # Only allow a list of trusted parameters through.
    def profile_params
      params.require(:profile).permit(:id,:weapon_id, :attacks, :skill, :strength, :armor_piercing, :damage)
    end
end
