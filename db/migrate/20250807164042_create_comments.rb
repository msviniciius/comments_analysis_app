class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.references :post, foreign_key: true
      t.integer :external_id
      t.text :content
      t.string :status
      t.text :translated_content

      t.timestamps
    end
  end
end
