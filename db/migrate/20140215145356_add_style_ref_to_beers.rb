class AddStyleRefToBeers < ActiveRecord::Migration
  def change
    add_reference :beers, :style, index: true
  end
end
