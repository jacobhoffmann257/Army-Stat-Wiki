class ModelsController < ApplicationController
  before_action :set_unit
  before_action :set_model, only: %i[ show edit update destroy ]


  # GET /models or /models.json
  def index
    @models = @unit.models.all
  end

  # GET /models/1 or /models/1.json
  def show
  end

  # GET /models/new
  def new
    @model = @unit.models.new
  end

  # GET /models/1/edit
  def edit
  end

  # POST /models or /models.json
  def create
    @model = @unit.models.new(model_params)

    respond_to do |format|
      if @model.save
        format.html { redirect_to model_url(@model), notice: "Model was successfully created." }
        format.json { render :show, status: :created, location: @model }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @model.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /models/1 or /models/1.json
  def update
    respond_to do |format|
      if @model.update(model_params)
        format.html { redirect_to model_url(@model), notice: "Model was successfully updated." }
        format.json { render :show, status: :ok, location: @model }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @model.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /models/1 or /models/1.json
  def destroy
    @model.destroy

    respond_to do |format|
      format.html { redirect_to models_url, notice: "Model was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_unit
    @unit = Unit.find(params[:unit_id])
  end

  def set_model
    @model = Model.find(params[:id])
  end

  def model_params
    params.require(:model).permit(:name, :unit_it, :movement, :toughness, :save_value, :invulnerable_save, :wounds, :leadership, :objective_control)
  end
end
