class AddPublicFigureToggleToPeopleFacebookProfile < ActiveRecord::Migration
  def change
    add_column :people, :facebook_type, :string
    Person.update_all facebook_type: Person::FacebookType::PERSON
  end
end
