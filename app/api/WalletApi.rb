class WalletApi < Grape::API
    version 'v1', using: :path
    format :json
    prefix :api

    resource :user do
        desc 'Retorna o saldo de um usúario'
        params do
            requires :id,type: Integer, desc:'ID do usuário'
        end
        get ':id' do
            User.find(params[:id]).wallet.value
        end
    end

    resource :transactions do
        desc 'Retorna o histórico de transações de um usuário dentro de um período de tempo'
        params do
          requires :id, type: Integer, desc: 'ID do usuário'
          requires :start_date, type: Date, desc: 'Data inicial do período'
          requires :end_date, type: Date, desc: 'Data final do período'
        end
      
        get ':id' do
          user = User.find(params[:id])
          wallet = user.wallet
          transactions = wallet.transactions.where(created_at: params[:start_date]..params[:end_date])
      
          transactions
        end
      end
      

    resource :wallet do

        desc 'Atualizar o saldo da carteira'
        params do
            requires :id, type: Integer, desc: 'ID do usuário'
            requires :transaction_type, type: String, desc:'Tipo de transação (C ou D)'
            requires :value, type: Float, desc: 'Valor da transação'
        end

        put ':id' do
            if params[:transaction_type] == 'C'

                wallet = User.find(params[:id]).wallet
                wallet.update(value: wallet.value + params[:value] )
                Transaction.create!(transaction_type: 'CREDITADO', value: params[:value], wallet: wallet)
                text = 'Valor foi Creditado'

            elsif params[:transaction_type] == 'D'

                wallet = User.find(params[:id]).wallet
                wallet.update(value: wallet.value - params[:value] )
                Transaction.create!(transaction_type: 'DEBITADO', value: params[:value], wallet: wallet)
                text = 'Valor foi DEBITADO'

            else
                text = 'Tipo de transação invalido'
            end
        end

    end
end
