require 'ulid'
module MCOS
  module Interactors
    module MenuOperations
      class GetMenu < Citrine::Operation
        include CommonFunction
        include Error
        
        class Success < Citrine::Operation::Success
          data do |ctx|
            {
              menus: ctx[:menu]
             }
          end
        end

        repository_alias :mcos_repository

        pass :before_run
        pass :get_menu

        def get_menu(context)
          context[:menu] = mcos_repository.run_sql(method(:list_menu), context[:params])
          p context[:menu]
        end

        def list_menu(db, params)
          p db
          sql = db.from(:menus)
          sql = sql.order(Sequel.desc(Sequel[:menus][:created_at]))
          sql.select(Sequel[:menus].*).all
        end

      end
    end
  end
end