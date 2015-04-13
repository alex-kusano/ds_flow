class RuleSetsController < ApplicationController
  before_action :set_rule_set, only: [:show, :edit, :update, :destroy]

  has_scope :by_code
  
  # GET /rule_sets
  # GET /rule_sets.json
  def index
    @rule_sets = apply_scopes(RuleSet).order(:code).page( params[:page] )
  end

  # GET /rule_sets/1
  # GET /rule_sets/1.json
  def show
    @rules = @rule_set.rules.page(params[:page])
  end

  # GET /rule_sets/new
  def new
    @rule_set = RuleSet.new
  end

  # GET /rule_sets/1/edit
  def edit
  end

  # POST /rule_sets
  # POST /rule_sets.json
  def create
    @rule_set = RuleSet.new(rule_set_params)

    respond_to do |format|
      if @rule_set.save
        format.html { redirect_to @rule_set, notice: 'Rule set was successfully created.' }
        format.json { render :show, status: :created, location: @rule_set }
      else
        format.html { render :new }
        format.json { render json: @rule_set.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rule_sets/1
  # PATCH/PUT /rule_sets/1.json
  def update
    respond_to do |format|
      if @rule_set.update(rule_set_params)
        format.html { redirect_to @rule_set, notice: 'Rule set was successfully updated.' }
        format.json { render :show, status: :ok, location: @rule_set }
      else
        format.html { render :edit }
        format.json { render json: @rule_set.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rule_sets/1
  # DELETE /rule_sets/1.json
  def destroy
    @rule_set.destroy
    respond_to do |format|
      format.html { redirect_to rule_sets_url, notice: 'Rule set was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_rule_set
      @rule_set = RuleSet.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def rule_set_params
      params.require(:rule_set).permit(:code, :routing_order)
    end
end
