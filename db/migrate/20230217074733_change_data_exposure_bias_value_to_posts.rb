class ChangeDataExposureBiasValueToPosts < ActiveRecord::Migration[6.1]
  def change
    change_column :posts, :exposure_bias_value, :string
  end
end
