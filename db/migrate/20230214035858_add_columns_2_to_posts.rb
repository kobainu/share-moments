class AddColumns2ToPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :camera, :string
    add_column :posts, :lens, :string
    add_column :posts, :iso_speed_ratings, :integer
  end
end
