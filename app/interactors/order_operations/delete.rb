require 'ulid'
module MCOS
  module Interactors
    module OrderOperations
      class Delete < Citrine::Operation
        include CommonFunction
        include Error
        
        class Success < Citrine::Operation::Success
          code "OK"
          message "Request is now completed."
        end

        repository_alias :mcos_repository

        pass :before_run
        step :find_order
        pass :delete

        def find_order(context)
          context[:order] = mcos_repository.find_order(id: context[:params][:order_id])
          if !context[:order]
            context[:result] = OrderNotFound.new(context)
            return false
          end
          true
        end

        def delete(context)
          context[:order].status = 'inactived'
          context[:order].save
        end

      end
    end
  end
end