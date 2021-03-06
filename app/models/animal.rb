class Animal < ActiveRecord::Base
  include CommonScopes
  include PublicActivity::Model
  tracked owner: ->(controller, _model) { controller.current_user },
          recipient: ->(controller, _model) { controller.current_user.organization },
          params: {
            author_name: ->(controller, _model) { controller.current_user.username },
            author_email: ->(controller, _model) { controller.current_user.email },
            object_name: ->(_controller, model) { model.name },
            summary: ->(_controller, model) { model.changes }
          }

  ANIMAL_IMAGE_OPTIONS = {
    storage: :s3,
    s3_protocol: 'https',
    s3_credentials: { access_key_id: ENV['S3_KEY'], secret_access_key: ENV['S3_SECRET'] },
    bucket: 'hospitium-static-v2',
    styles: { large: '1060x1060#', medium: '520x360#', thumb: '280x280#' },
    default_url: 'https://d4uktpxr9m70.cloudfront.net/images/no-animal-retina.png',
    url: '/system/:class/:hash/:style/:filename',
    # :url  => "/system/:class_migration/:animalname_:orgname_:createdat/:style/:filename",
    hash_secret: ENV['SALTY']
  }.freeze

  has_attached_file :image, ANIMAL_IMAGE_OPTIONS
  has_attached_file :second_image, ANIMAL_IMAGE_OPTIONS
  has_attached_file :third_image, ANIMAL_IMAGE_OPTIONS
  has_attached_file :fourth_image, ANIMAL_IMAGE_OPTIONS

  belongs_to :organization
  belongs_to :species
  belongs_to :shelter
  belongs_to :animal_color
  belongs_to :animal_sex
  belongs_to :spay_neuter
  belongs_to :biter
  belongs_to :status

  has_many :animal_weights
  has_many :notes
  has_many :adopt_animals
  has_many :adoption_contacts, through: :adopt_animals
  has_many :relinquish_animals
  has_many :relinquishment_contacts, through: :relinquish_animals
  has_many :documents, as: :documentable
  has_many :shots

  attr_accessible :name, :previous_name, :species_id, :special_needs, :diet, :date_of_intake, :date_of_well_check, :shelter_id, :deceased,
                  :deceased_reason, :adopted_date, :animal_color_id, :image, :second_image, :third_image, :fourth_image, :public, :birthday, :animal_sex_id, :spay_neuter_id,
                  :biter_id, :status_id, :video_embed, :microchip, :impressions_count, :archived, :fostered_date

  validates :name, :date_of_intake, :organization, :species, :animal_color, :biter, :spay_neuter, :animal_sex, :status, presence: true
  validates_attachment_content_type :image, content_type: ['image/jpeg', 'image/pjpeg', 'image/jpg', 'image/png']
  validates_attachment_content_type :second_image, content_type: ['image/jpeg', 'image/pjpeg', 'image/jpg', 'image/png']
  validates_attachment_content_type :third_image, content_type: ['image/jpeg', 'image/pjpeg', 'image/jpg', 'image/png']
  validates_attachment_content_type :fourth_image, content_type: ['image/jpeg', 'image/pjpeg', 'image/jpg', 'image/png']
  validates_attachment_size :image, less_than: 4.megabytes
  validates_attachment_size :second_image, less_than: 4.megabytes

  delegate :name, to: :species, prefix: :species, allow_nil: true
  delegate :name, :phone_number, :address, :city, :state, :zip_code, :website, :email, to: :organization, prefix: :organization, allow_nil: true
  delegate :sex, to: :animal_sex, allow_nil: true
  delegate :spay, to: :spay_neuter, allow_nil: true
  delegate :color, to: :animal_color, allow_nil: true
  delegate :value, to: :biter, prefix: :biter, allow_nil: true
  delegate :name, to: :shelter, prefix: :shelter, allow_nil: true

  # is_impressionable counter_cache: true, unique: :session_hash

  def calculate_animal_age
    if birthday.blank?
      age = ''
    else
      age = "#{(Time.now.year - birthday.year)} years"
      if age == '0 years'
        age = "#{(Time.now.month - birthday.month)} months"
        age = "#{(Time.now.day - birthday.day)} days" if age == '0 months'
      end
    end
    age
  end

  def formatted_deceased_date
    formatted_date('deceased')
  end

  def formatted_intake_date
    formatted_date('date_of_intake')
  end

  def formatted_well_date
    formatted_date('date_of_well_check')
  end

  def formatted_adopted_date
    formatted_date('adopted_date')
  end

  def formatted_fostered_date
    formatted_date('fostered_date')
  end

  def formatted_date(type)
    if send(type).blank?
      age = ''
    else
      age = send(type).strftime('%a, %b %e %Y')
    end
    age
  end

  # ===============
  # = CSV support =
  # ===============
  comma do
    id 'ID'
    name 'Name'
    previous_name 'Previous Name'
    birthday 'Birthday'
    species 'Species', &:name
    animal_color 'Animal Color', &:color
    spay_neuter 'Spay / Neuter', &:spay
    biter 'Biter', &:value
    animal_sex 'Sex', &:sex
    public 'Public' do |p| p == 1 ? 'yes' : 'no' end
    status 'Status' do |s| s.try(:status) end
    special_needs 'Special Needs'
    diet 'Diet'
    date_of_well_check 'Date of Well Check'
    deceased 'Deceased Date'
    deceased_reason 'Deceased Reason'
    adopted_date 'Adopted Date'
  end
end
