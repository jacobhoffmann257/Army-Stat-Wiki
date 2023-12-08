class UnitAbilitiesController < ApplicationController
  before_action :set_unit_ability, only: %i[ show edit update destroy ]

  # GET /unit_abilities or /unit_abilities.json
  def index
    @unit_abilities = UnitAbility.all
  end

  # GET /unit_abilities/1 or /unit_abilities/1.json
  def show
  end

  # GET /unit_abilities/new
  def new
    @unit_ability = UnitAbility.new
  end

  # GET /unit_abilities/1/edit
  def edit
  end

  # POST /unit_abilities or /unit_abilities.json
  def create
    @unit_ability = UnitAbility.new(unit_ability_params)

    respond_to do |format|
      if @unit_ability.save
        format.html { redirect_to unit_ability_url(@unit_ability), notice: "Unit ability was successfully created." }
        format.json { render :show, status: :created, location: @unit_ability }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @unit_ability.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /unit_abilities/1 or /unit_abilities/1.json
  def update
    respond_to do |format|
      if @unit_ability.update(unit_ability_params)
        format.html { redirect_to unit_ability_url(@unit_ability), notice: "Unit ability was successfully updated." }
        format.json { render :show, status: :ok, location: @unit_ability }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @unit_ability.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /unit_abilities/1 or /unit_abilities/1.json
  def destroy
    @unit_ability.destroy

    respond_to do |format|
      format.html { redirect_to unit_abilities_url, notice: "Unit ability was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_unit_ability
      @unit_ability = UnitAbility.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def unit_ability_params
      params.require(:unit_ability).permit(:unit_id, :ability_id)
    end
end
