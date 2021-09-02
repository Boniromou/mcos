require 'ulid'
module MCOS
  module Interactors
    module MenuOperations
      class Delete < Citrine::Operation
        include CommonFunction
        include Error
        
        class Success < Citrine::Operation::Success
          code "OK"
          message "Request is now completed."
        end

        repository_alias :mcos_repository

        pass :before_run
        step :find_menu
        pass :delete

        def find_menu(context)
          p context[:menu] = mcos_repository.find_menu(id: context[:params][:menu_id])
          if !context[:menu]
            context[:result] = MenuNotFound.new(context)
            return false
          end
          true
        end

        def delete(context)
          context[:menu].status = 'inactived'
          context[:menu].save
        end

      end
    end
  end
end