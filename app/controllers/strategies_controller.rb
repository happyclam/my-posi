class StrategiesController < ApplicationController
  before_action :set_strategy, only: [:show, :edit, :update, :destroy, :paint]

  def index
p "strategies.index"
    @user = User.find_by_id(params[:user_id])
    # if !@user
    #   redirect_to root_url
    #   return
    # end
#    @strategies = User.find_by_id(params[:user_id]).strategies.page(params[:page])
    @strategies = @user.strategies.page(params[:page])
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @strategies }
    end

  end

  def show
p "strategies.show"
#    @strategy = Strategy.find(params[:id])
    unless @strategy.positions == []
#      @graphs = draw_graph(@strategy)
      @graphs = @strategy.draw_graph
    end
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @strategy }
    end

  end

  def edit
p "strategies.edit"
#    @strategy = Strategy.find(params[:id])

  end

  def copy
p "strategies.copy"
    @org_strategy = Strategy.find(params[:id])
    @user = @org_strategy.user
    @strategy = Strategy.create(:name => @org_strategy.name, :draw_type => @org_strategy.draw_type, :range => @org_strategy.range, :interest => @org_strategy.interest, :user_id => @org_strategy.user_id)
    if @org_strategy.positions.length > 0
      @org_strategy.positions.each do |org|
        @strategy.positions.create(:distinct => org.distinct,
                                   :sale => org.sale,
                                   :exercise => org.exercise,
                                   :unit => org.unit,
                                   :number => org.number,
                                   :expiration => org.expiration,
                                   :maturity => org.maturity
                                   )
      end
    end

    respond_to do |format|
      format.html { redirect_to strategies_path(:user_id => @user.id) }
    end
  end

  def destroy
p "strategies.destroy"
#    @strategy = Strategy.find(params[:id])
    @user = @strategy.user
    @strategy.destroy

    respond_to do |format|
      format.html { redirect_to strategies_url(:user_id => @user.id) }
      format.json { head :no_content }
    end
  end

  def create
p "strategies.create"
    # @user = current_user
    # @strategies = @user.strategies.page(session[:page])
    # buf = strategy_params
    # buf[:range] = RANGE_DEFAULT
    # buf[:user_id] = @user.id
    # @strategy = Strategy.new(buf)

    strategy_params = params.require(:strategy).permit(:user_id, :name, :interest)
    @strategy = Strategy.new(strategy_params)
    respond_to do |format|
      if @strategy.save
        format.html { redirect_to @strategy, notice: 'Strategy was successfully created.' }
        format.json { render json: @strategy, status: :created, location: @strategy }
      else
        flash[:notice] = @strategy.errors.full_messages.to_s
        format.html { redirect_to strategies_path(:user_id => params[:user_id]) }
        format.json { render json: @strategy.errors, status: :unprocessable_entity }
      end
    end

  end

  def paint
p "strategy.paint"
    unless @strategy.positions == []
      @graphs = @strategy.draw_graph
    end
###    render
    render :json => @graphs.to_json
  end

  def update
p "strategies.update"
#    @strategy = Strategy.find(params[:id])
    if @strategy.update_attributes(strategy_params)
      unless @strategy.positions == []
        @graphs = @strategy.draw_graph
      end
    else
      flash[:notice] = "更新に失敗しました"
    end
    respond_to do |format|
      #strategies/index画面から来たかstrategies/show画面から来たかnameパラメータの有無で判断
      if params[:strategy][:name] != nil
        format.html { redirect_to strategies_path(:user_id => @strategy.user_id) }
      else
        format.html { redirect_to @strategy }
#        render
#        render template: "strategies/paint.js.erb"
#        render :json => @graphs.to_json
#        format.js { render template: "strategies/paint.js.erb"}
#p request.method
        # format.js {
        #   if request.method == "PATCH"
        #     render :json => @graphs.to_json
        #   else
        #     render template: "strategies/paint.js.erb"
        #   end
        # }
        format.js { render :json => @graphs.to_json }
      end
    end
  end

   def children
p "strategies.children"
    #認証済みの時しか使わないメソッドなのでcurrent_userオブジェクトを使う
    @strategy = Strategy.find_by_id_and_user_id(params[:strategy_id], current_user.id)
    @strategy.positions.each do |p|
      p.destroy
    end

    respond_to do |format|
      format.html { redirect_to(strategy_path(:id => @strategy.id)) }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_strategy
      @strategy = Strategy.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def strategy_params
      params.require(:strategy).permit(:name, :draw_type, :range, :interest, :sigma)
#      params.require(:strategy).permit(:name, :draw_type, :range, :interest, :sigma, :user_id)
    end
end
