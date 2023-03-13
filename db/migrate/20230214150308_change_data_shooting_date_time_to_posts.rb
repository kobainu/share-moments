class ChangeDataShootingDateTimeToPosts < ActiveRecord::Migration[6.1]
  def change
    change_column :posts, :shooting_date_time, :string
  end
end
