Sequel.migration do
    change do
      create_table :orders do
        primary_key :id
  
        column :table_number, Integer,  null: false
        column :status, String, null: false
  
        column :created_at,  DateTime, null: false
        column :updated_at,  DateTime, null: false
      end
    end
  end