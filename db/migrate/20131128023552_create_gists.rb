class CreateGists < ActiveRecord::Migration
  def change
    create_table :gists do |t|
      t.string :filename
      t.string :language
      t.string :content_type
      t.string :raw_url
      t.integer :size
      t.text :content
      t.timestamps
    end
  end
end
