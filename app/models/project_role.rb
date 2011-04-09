class ProjectRole
  #TODO:Remove project role as it is no longer relevant
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name
  field :manager, :type => Boolean
  field :role

  references_many :project_member
  referenced_in :account
 
  validates_presence_of :name

#  belongs_to :project_member
#
#  before_save :check_and_update_manager
  
#  def check_and_update_manager
#    manager = ProjectRole.manager
#
#    unless manager.nil?
#      if self.manager
#        manager.manager = false
#        manager.save
#      end
#    end
#  end
end