require 'ulid'
module MCOS
  module Interactors
    module OrderOperations
      class CreateOrder < Citrine::Operation
        include CommonFunction
        include Error

        class Success < Citrine::Operation::Success
              code "OK"
              message "Request is now completed."
        end

        repository_alias :mcos_repository

        pass :before_run
        step :create_order
        step :mapping

        def create_order(context)
          context[:order] = mcos_repository.create_order({
            table_id: context[:params][:table_id],
            status: 'created',
            operator: context[:params][:operator]
          })
          true
        end

        def mapping(context)
          context[:params][:order_details].each do |data|
            d = JSON.parse(data.gsub('=>', ':'))
            context[:order_detail] = mcos_repository.create_order_detail({
              order_id: context[:order].id,
              menu_id: d["menu_id"],
              remark: d["remark"],
              quantity: d["quantity"],
              total: d["quantity"] * d["price"].to_i
            })
          true
        end
        end
 
      end
    end
  end
end