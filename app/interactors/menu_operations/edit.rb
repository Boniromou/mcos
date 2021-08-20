require 'ulid'
module MCOS
  module Interactors
    module MenuOperations
      class Edit < Citrine::Operation
        include CommonFunction
        include Error
        
        class Success < Citrine::Operation::Success
          code "OK"
          message "Request is now completed."
        end

        repository_alias :mcos_repository

        pass :before_run
        step :find_menu
        pass :edit

        def find_menu(context)
          context[:menu] = mcos_repository.find_menu(id: context[:params][:menu_id])
          if !context[:menu]
            context[:result] = MenuNotFound.new(context)
            return false
          end
          true
        end

        def edit(context)
          context[:menu].name = context[:params][:name]
          context[:menu].price = context[:params][:price]
          context[:menu].type = context[:params][:type]
          context[:menu].quantity = context[:params][:quantity]
          context[:menu].save
        end


      end
    end
  end
end