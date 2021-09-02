require 'ulid'
module MCOS
  module Interactors
    module OrderOperations
      class ListOrdersByTable < Citrine::Operation
        include CommonFunction
        include Error

        class Success < Citrine::Operation::Success
          data do |ctx|
            {
              orders_id: ctx[:orders_id],
              orders_detail: ctx[:orders_detail]
            }
          end
        end

        repository_alias :mcos_repository

        pass :before_run
        pass :get_orders
        pass :get_orders_detail

        def get_orders(context)
          context[:orders] = mcos_repository.filter_orders(table_id: context[:params][:table_id])
          context[:orders_id] = context[:orders].map{ |data| data.id }
        end

        def get_orders_detail(context)
          context[:orders_detail] = mcos_repository.filter_order_details(:order_id => context[:orders_id])
          context[:orders_detail] = context[:orders_detail].map(&:to_h)
        end

      end 
    end
  end
end 