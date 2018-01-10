class AddCollaboratorsToWikis < ActiveRecord::Migration[5.1]
  def change
    add_column :wikis, :collaborators, :text
  end
end
