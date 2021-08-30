require 'ulid'
module MCOS
  module Interactors
    module TableOperations
      class ListTable < Citrine::Operation
        include CommonFunction
        include Error

        class Success < Citrine::Operation::Success
          data do |ctx|
            { 
              table: ctx[:table]
            }
          end
        end

        repository_alias :mcos_repository

        pass :before_run
        pass :get_table

        def get_table(context)
          context[:table] = mcos_repository.run_sql(method(:list_table), context[:params])
        end

        def list_table(db, params)
          sql = db.from(:tables)
          sql = sql.order(Sequel.desc(Sequel[:tables][:created_at]))
          sql.select(Sequel[:tables].*).all
        end
      end
    end
  end
end