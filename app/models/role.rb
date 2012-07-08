# Role model
class Role < ActiveRecord::Base

  has_many :permissions
  has_many :users, :through => :permissions # use join table permissions
  
  attr_accessible :name
  
  # def role?(role)
  #     return !!self.roles.find_by_name(role.to_s.camelize)
  # end
  
end