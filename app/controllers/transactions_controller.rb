class TransactionsController < ApplicationController
  before_action :set_transaction, only: %i[ show edit update destroy ]

  # GET /transactions or /transactions.json
  def index
    @transactions = Transaction.all
  end

  # GET /transactions/1 or /transactions/1.json
  def show
  end

  # GET /transactions/new
  def new
 
    unless params[:wallet_id].nil?
      @wallet = Wallet.find(params[:wallet_id]) if params[:wallet_id]
      @user = User.find_by(wallet_id: @wallet.id)
    end
    @transaction = Transaction.new
  end

  # GET /transactions/1/edit
  def edit
  end

  # POST /transactions or /transactions.json
  def create
    @transaction = Transaction.new(transaction_params)
    #momento que associa a carteira a transação criada
    @transaction.wallet_id = Wallet.find(params[:wallet_id]) if params[:wallet_id]

    respond_to do |format|
      if @transaction.save
        #Condicional para somar ou subtrair o saldo da carteira
        if @transaction.transaction_type == 'CREDITADO'
          @transaction.wallet.update(value: @transaction.wallet.value + @transaction.value)
    
        elsif @transaction.transaction_type == 'DEBITADO'
          @transaction.wallet.update(value: @transaction.wallet.value - @transaction.value)
        end
        
        format.html { redirect_to transaction_url(@transaction), notice: "Transação Criada Com Sucesso." }
        format.json { render :show, status: :created, location: @transaction }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /transactions/1 or /transactions/1.json
  def update
    respond_to do |format|
      if @transaction.update(transaction_params)
        format.html { redirect_to transaction_url(@transaction), notice: "Transação Atualizada Com Sucesso." }
        format.json { render :show, status: :ok, location: @transaction }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /transactions/1 or /transactions/1.json
  def destroy
    @transaction.destroy!

    respond_to do |format|
      format.html { redirect_to transactions_url, notice: "Transação Deletada Com Sucesso." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_transaction
      @transaction = Transaction.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def transaction_params
      params.require(:transaction).permit(:transaction_type, :value, :wallet_id)
    end
end
