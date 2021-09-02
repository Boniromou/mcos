module CommonFunction
  include Util
  include Error

  def before_run(context)
    function_log(@random_key, self.class.name.split('::').last, __method__)
    logger_msg(@random_key, 'params: ', {:params => context[:params]})
    @random_key = random_string(20)
  end

  # def get_orders(context)
  #   context[:orders] = mcos_repository.run_sql(method(:get_order_id_by_table), context[:params])
  #   context[:orders_id] = context[:orders].map { |data| data[:id] }
  # end
 
  # def get_order_id_by_table(db, params)
  #   sql = db.from(:orders).where(Sequel[:orders][:table_id] => params[:table_id], Sequel[:orders][:status] => 'created' )
  #   sql.select(Sequel[:orders].*).all
  # end

  # def get_orders_detail(context)
  #   context[:orders_detail] = mcos_repository.run_sql(method(:get_order_detail), context: context).to_a
  # end

  # def get_order_detail(db, context:)
  #   sql = db.from(:order_details).inner_join(:menus, :id => :menu_id)
  #   sql = sql.where(:order_id => context[:orders_id])
  #   sql
  # end

end