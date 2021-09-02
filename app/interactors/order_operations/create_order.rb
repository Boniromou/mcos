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
        step :inactive_table
        step :create_order
        step :create_order_detail

        def inactive_table(context)
          context[:table] = mcos_repository.find_table(id: context[:params][:table_id])
          context[:table].status = "inactvated"
          context[:table].save
          true
        end

        def create_order(context)
          # context[:params][:order_details]
          context[:order] = mcos_repository.create_order({
            table_id: context[:params][:table_id],
            status: 'created',
            operator: context[:params][:operator]
          })
          true
        end

        def create_order_detail(context)
          context[:params][:order_details].each do |data|
            d = JSON.parse(data.gsub('=>', ':'))
            context[:order_detail] = mcos_repository.create_order_detail({
              order_id: context[:order].id,
              menu_id: d["menu_id"],
              remark: d["remark"],
              quantity: d["quantity"],
              total: d["quantity"] * d["price"].to_i
            })
          end
          true
        end

      end
    end
  end
end