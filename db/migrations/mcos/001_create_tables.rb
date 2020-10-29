Sequel.migration do
    change do
      create_table :tables do
        primary_key :id
  
        column :order_id, Integer,  null: false
        column :table_number, Integer,  null: false
        column :status, String, null: false
  
        column :created_at,  DateTime, null: false
        column :updated_at,  DateTime, null: false
      end
    end
  end