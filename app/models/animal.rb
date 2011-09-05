class Animal < ActiveRecord::Base
  belongs_to :organization
  belongs_to :species
  belongs_to :shelter
  belongs_to :animal_color
  has_many :animal_weights
  has_one :relinquishment_contact
  
  before_create :create_uuid
  
  validates_presence_of :name, :date_of_intake, :organization, :species, :color, :biter, :spay_neuter, :sex, :status
  
  # settings for rails admin views
  rails_admin do
    show do
      exclude_fields :uuid
    end
    create do
      #exclude_fields :uuid
      field :name
      field :previous_name
      field :status, :enum
      field :species
      field :age
      field :sex, :enum
      field :animal_color
      field :spay_neuter, :enum
      field :biter, :enum
      field :date_of_intake
      field :date_of_well_check
      field :organization
      field :shelter
      field :special_needs
      field :diet
      field :adopted_date
      field :deceased
      field :deceased_reason
      group :animal_weights
    end
    edit do
      field :name
      field :previous_name
      field :status, :enum
      field :species
      field :age
      field :sex, :enum
      field :color, :enum
      field :spay_neuter, :enum
      field :biter, :enum
      field :date_of_intake
      field :date_of_well_check
      field :organization
      field :shelter
      field :special_needs
      field :diet
      field :adopted_date
      field :deceased
      field :deceased_reason
      group :animal_weights
    end
    list do
      exclude_fields :uuid
    end
  end
  
  #create uuid
  def create_uuid()
    self.uuid = UUIDTools::UUID.random_create.to_s
  end
  
  #drop down options for some fields
  def color_enum
     ['white', 'black', 'brown', 'gray', 'pink']
  end
  
  def biter_enum
     ['No', 'Yes']
  end
  
  def spay_neuter_enum
     ['No', 'Yes']
  end
  
  def sex_enum
     ['Male', 'Female']
  end
  
  def status_enum
     ['Adoptable', 'New Intake', 'Sanctuary', 'Sick', 'Deceased', 'Adopted', 'Foster Care']
  end
  
end