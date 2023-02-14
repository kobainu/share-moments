class AddHideLocationInfoToPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :hide_location_info, :boolean
  end
end
