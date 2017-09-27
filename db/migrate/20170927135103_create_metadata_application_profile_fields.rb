class CreateMetadataApplicationProfileFields < ActiveRecord::Migration[5.1]
  def change
    create_table :metadata_application_profile_fields do |t|
      t.string :label
      t.string :field_type
      t.string :requirement_designation
      t.string :validation
      t.boolean :multiple
      t.string :controlled_vocabulary
      t.string :default_value
      t.string :display_name
      t.string :display_transformation

      t.timestamps
    end
  end
end
