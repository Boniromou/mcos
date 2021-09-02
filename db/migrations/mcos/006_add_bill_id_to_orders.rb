Sequel.migration do
  up do
    add_column do
      foreign_key :bill_id, :bills, null: false, :type => Integer
    end

  down do
    drop_column :orders, :bill_id
  end
end      
