class AddColumns3ToPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :exposure_time, :string
    add_column :posts, :f_number, :float
    add_column :posts, :exposure_bias_value, :float
    add_column :posts, :focal_length, :integer
    add_column :posts, :shooting_date_time, :time
  end
end
