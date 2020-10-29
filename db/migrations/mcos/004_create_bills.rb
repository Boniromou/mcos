Sequel.migration do
    change do
      create_table :menus do
        primary_key :id
  
        column :order_id, Integer,  null: false
        column :total, Integer,  null: false
  
        column :created_at,  DateTime, null: false
        column :updated_at,  DateTime, null: false
      end
    end
  end