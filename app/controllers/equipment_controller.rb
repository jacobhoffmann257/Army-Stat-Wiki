class EquipmentController < ApplicationController
  before_action :set_model
  before_action :set_equipment, only: %i[ show edit update destroy ]
  before_action :authorize_user
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  # GET /equipment or /equipment.json
  def index
    @equipment = Equipment.all
  end

  # GET /equipment/1 or /equipment/1.json
  def show
  # if this logic is not being used anymore, you should delete this commented code and refer to comments for explanation instead

    #@melee = Equipment.melee_weapons
  end

  # GET /equipment/new
  def new
    @equipment = Equipment.new
  end

  # GET /equipment/1/edit
  def edit
  end

  # POST /equipment or /equipment.json
  def create
    @equipment = Equipment.new(equipment_params)

    respond_to do |format|
      if @equipment.save
        format.html { redirect_to equipment_url(@equipment), notice: "Equipment was successfully created." }
        format.json { render :show, status: :created, location: @equipment }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @equipment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /equipment/1 or /equipment/1.json
  def update
    respond_to do |format|
      if @equipment.update(equipment_params)
        format.html { redirect_to equipment_url(@equipment), notice: "Equipment was successfully updated." }
        format.json { render :show, status: :ok, location: @equipment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @equipment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /equipment/1 or /equipment/1.json
  def destroy
    @equipment.destroy

    respond_to do |format|
      format.html { redirect_to equipment_index_url, notice: "Equipment was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_equipment
      @equipment = Equipment.find(params[:id])
    end

    def set_model
      @model = Model.find(params[:id])
    end
    
    # Only allow a list of trusted parameters through.
    def equipment_params
      params.require(:equipment).permit(:model_id, :weapon_id, :limits, :slot)
    end
    
    # DRY
    def user_not_authorized
      flash[:alert]
      redirect_to(home_path)
    end

    def authorize_user
      if current_user
        authorize current_user
      else
        flash[:alert]= "You aren't authorized for that."
        redirect_back fallback_location: root_url
      end
    end

end
