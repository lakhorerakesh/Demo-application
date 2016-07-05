class AddEmbedLinkToVideo < ActiveRecord::Migration
  def change
    add_column :videos, :embed_link, :string
  end
end
