require 'ulid'
module MCOS
  module Interactors
    module MenuOperations
      class Create < Citrine::Operation
        include CommonFunction
        include Error
        
        class Success < Citrine::Operation::Success
          code "OK"
          message "Request is now completed."
        end

        repository_alias :mcos_repository

        pass :before_run
        step :create

        def create(context)
          p context[:params]
          context[:menu] = mcos_repository.create_menu({
            price: context[:params][:price],
            type: context[:params][:type],
            name: context[:params][:name],
            quantity: context[:params][:quantity],
            status: 'actived'
          })
          true
        end


      end
    end
  end
end