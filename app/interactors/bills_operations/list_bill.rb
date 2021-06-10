require 'ulid'
module MCOS
  module Interactors
    module MenuOperations
      class ListBill < Citrine::Operation
        include CommonFunction
        include Error
        
        class Success < Citrine::Operation::Success
          data do |ctx|
            {
              bills: ctx[:bill]
             }
          end
        end

        repository_alias :mcos_repository

        pass :before_run
        pass :get_menu

        def get_menu(context)
          context[:bill] = mcos_repository.run_sql(method(:list_bill), context[:params])
        end

        def list_bill(db, params)
          sql = db.from(:bill)
          sql = sql.order(Sequel.desc(Sequel[:bill][:created_at]))
          sql.select(Sequel[:bill].*).all
        end

      end
    end
  end
end