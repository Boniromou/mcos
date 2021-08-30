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
              order_ids: ctx[:order_ids],
              order_detail: ctx[:order_detail]
            }
          end
        end

        repository_alias :mcos_repository

        pass :before_run
        pass :get_orders
        # pass :get_order_detail_by_ids
        # pass :get_order_ids

        def get_orders(context)
          context[:order_ids] = mcos_repository.run_sql(method(:get_order_id_by_table), context[:params]).map { |data| data[:id] }
          context[:order_detail] = mcos_repository.run_sql(method(:get_order_detail), context: context).to_a
          # p context[:menus] = mcos_repository.run_sql()
          # p context[:order_detail].map { |data| data[:menu_id] }
          # mcos_repository.find_menu(menu_id: context[:order_detail])
        end   

        def get_order_id_by_table(db, params)
          sql = db.from(:orders).where(Sequel[:orders][:table_id] => params[:table_id], Sequel[:orders][:status] => 'created' )
          sql.select(Sequel[:orders].*).all
        end

        def get_order_detail(db, context:)
          sql = db.from(:order_details).inner_join(:menus, :id => :menu_id)
          sql = sql.where(:order_id => context[:order_ids])
          sql
        end

      end
    end
  end
end 