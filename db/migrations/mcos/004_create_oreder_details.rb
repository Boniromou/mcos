Sequel.migration do
    change do
      create_table :order_details do
        primary_key :id, :type => Integer, :unsigned => true, :auto_increment => true
        foreign_key :order_id, :orders, null: false, :type => Integer

        foreign_key :menu_id, :menus, null: false, :type => Integer
        column :quantity, Integer,  null: false
        column :total,  Integer, null: false
        column :remark,  String
  
        column :created_at,  DateTime, null: false
        column :updated_at,  DateTime, null: false
      end
    end
  end