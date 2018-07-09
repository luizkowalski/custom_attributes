class AddIndexToCustomAttributes < ActiveRecord::Migration[5.1]
  def change
    add_index :custom_attributes, [:user_id, :company_id, :field_name], name: 'index_on_custom_attributes', unique: true
  end
end
