Sequel.migration do
  up do
    create_table :bills do
      primary_key :id
      column :is_member, String
      column :status,  String, null: false
      column :total, String
      
      column :created_at,  DateTime, null: false
      column :updated_at,  DateTime, null: false
    end
  end
  

  down do
    drop_table :bills
  end
end