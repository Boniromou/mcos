require 'ulid'
module MCOS
  module Interactors
    module TableOperations
      class Checkout < Citrine::Operation
        include CommonFunction
        include Error

        class Success < Citrine::Operation::Success
          # data do |ctx|
          #   { 
          #     table: ctx[:table]
          #   }
          # end
          code "OK"
          message "Request is now completed."
        end

        repository_alias :mcos_repository

        pass :before_run
        pass :actvate_table
        pass :get_orders
        pass :checkout_all_order
        # pass :create_bill

        def actvate_table(context)
          context[:table] = mcos_repository.find_table(id: context[:params][:table_id])
          # if !context[:table]
          #   context[:result] = TableNotFound.new(context)
          #   return false
          # end
          context[:table].status = 'testing'
          context[:table].save
          true
        end

        def get_orders(context)                                 
          context[:orders] = mcos_repository.filter_orders(table_id: context[:params][:table_id], status: 'created')
        end

        def checkout_all_order(context)
          context[:orders].map { |data| data.status = 'testing' }
          mcos_repository.save_changes(*context[:orders])
        end       

        def create_bill(context)          
          context[:bills] = mcos_repository.create_bill({
            is_member: context[:params][:is_member]
          })
        end

      end
    end
  end
end