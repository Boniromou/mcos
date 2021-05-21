Sequel.migration do
    change do
      create_table :orders do
        primary_key :id, :type => Integer, :unsigned => true, :auto_increment => true
        foreign_key :table_id, :tables, null: false, :type => Integer
        foreign_key :bill_id, :bills, null: false, :type => Integer

        column :foods, String, null: false
        column :status, String, null: false
        column :remark, String
        column :operator, String
  
        column :created_at,  DateTime, null: false
        column :updated_at,  DateTime, null: false
      end
    end
  end