Sequel.migration do
    change do
      create_table :orders do
        primary_key :id, :type => Integer, :unsigned => true, :auto_increment => true
        foreign_key :table_id, :tables, null: false, :type => Integer
        column :total,  Integer
        column :remark,  String
        column :operator,  String
        column :status,  String
  
        column :created_at,  DateTime, null: false
        column :updated_at,  DateTime, null: false
      end
    end
  end