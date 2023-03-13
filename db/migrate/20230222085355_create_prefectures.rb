class CreatePrefectures < ActiveRecord::Migration[6.1]
  def change
    create_table :prefectures do |t|
      t.references :region, null: false, foreign_key: true
      t.string :name

      t.timestamps
    end
  end
end
