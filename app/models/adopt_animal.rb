# adopt animal is the join table between aniamals and adoption contacts
class AdoptAnimal < ActiveRecord::Base
  belongs_to :animal
  belongs_to :adoption_contact
  
end