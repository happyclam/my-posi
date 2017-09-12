class PositionsController < ApplicationController
  before_action :set_position, only: [:show, :edit, :update, :destroy]

  def edit
p "positions.edit"
#    @user = User.find(params[:user_id])
    @user = @position.strategy.user
  end

  def create
p "positions.create"
    buf = position_params
    buf[:strategy_id] = params[:strategy_id]
    @position = Position.new(buf)
    if @position.save
      flash[:notice] = "Position was successfully created"
      render :js => "window.location = '#{strategy_path(:id=>@position.strategy_id)}'"
    else
      flash[:notice] = "Position was not be created"
    end

  end

  def update
p "positions.update"
    respond_to do |format|
      if @position.update(position_params)
        format.html { redirect_to strategy_path(@position.strategy), notice: 'Position was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { redirect_to strategy_path(@position.strategy), notice: 'Update failed.' }
        format.json { render json: @position.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
p "positions.destroy"
#    @position = Position.find(params[:id])
    @position.destroy
    render :js => "window.location = '#{strategy_path(:id=>@position.strategy_id)}'"
    # respond_to do |format|
    #   format.html { redirect_to positions_url }
    #   format.json { head :no_content }
    # end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_position
      @position = Position.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def position_params
      params.require(:position).permit(:distinct, :sale, :exercise, :expiration, :maturity, :number, :unit, :ym_expiration)
    end
end
