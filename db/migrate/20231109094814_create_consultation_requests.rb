class CreateConsultationRequests < ActiveRecord::Migration[7.1]
  def change
    create_table :consultation_requests do |t|
      t.references :patient, null: false, foreign_key: true, on_delete: :cascade
      t.text :text

      t.timestamps
    end
  end
end
