require 'ulid'
module MCOS
  module Interactors
    module OrderOperations
      class CreateOrder < Citrine::Operation
        include CommonFunction
        include Error

        class Success < Citrine::Operation::Success
          data do |ctx|
            { 
              code "OK"
              message "Request is now completed."
            }
          end
        end

        repository_alias :mcos_repository

        pass :before_run
        step :create_order

        def create_order(context)
          context[:orders] = mcos_repository.create_order({
            bill_id: context[:params][:bill_id],
            table_id: context[:params][:table_id],
            foods: context[:params][:foods],
            status: 'activated',
            remark: context[:params][:remark],
            operator: context[:params][:operator]
          })
        end
 
      end
    end
  end
end