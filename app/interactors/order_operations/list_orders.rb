require 'ulid'
module MCOS
  module Interactors
    module OrderOperations
      class ListOrder < Citrine::Operation
        include CommonFunction
        include Error

        class Success < Citrine::Operation::Success
              code "OK"
              message "Request is now completed."
        end

        repository_alias :mcos_repository

        pass :before_run
        step :list_order

        def get_order(context)
          context[:orders] = mcos_repository.run_sql(method(:))
        end

        
        def get_table(context)
          context[:table] = mcos_repository.run_sql(method(:list_order), context[:params])
        end

        def list_order(db, params)
          sql = db.from(:order_detail)
          sql = sql.where(Sequel[:order_detail][:order_id] =>Type::SERVICE)
          sql = sql.order(Sequel.desc(Sequel[:tables][:created_at]))
          sql.select(Sequel[:tables].*).all
        end

        # def mapping(context)
        #   context[:params][:order_details].each do |data|
        #     d = JSON.parse(data.gsub('=>', ':'))
        #     context[:order_detail] = mcos_repository.create_order_detail({
        #       order_id: context[:order].id,
        #       menu_id: d["menu_id"],
        #       remark: d["remark"],
        #       quantity: d["quantity"],
        #       total: d["quantity"] * d["price"].to_i
        #     })
        #   true
        # end
        
        end
 
      end
    end
  end
end