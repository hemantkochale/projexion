class FeatureStatus
  include Mongoid::Document
  include Mongoid::Timestamps

  field :display_name
  field :key
  field :position, :type => Integer, :default => 1
  field :color
  field :default, :type => Boolean
  field :system, :type => Boolean

  scope :ordered, asc(:position)

  referenced_in :account

  references_many :features

  before_create :set_position, :set_key

  validates_presence_of :display_name, :color

  #TODO: Before delete, ensure there is at least one status
  
  DIRECTION_UP = 'up'
  DIRECTION_DOWN = 'down'

  def set_key
    self.key = self.display_name.downcase.gsub(/\?|!|@|#|%|&|\*|\(|\)|>|<|\\|\||\{|\}|\[|\]|'|"|\.|,/, '').gsub(/\s+/, '-').strip.slice(0,100)
  end
  
  def hash_color
    '#'+self.color
  end

  def system?
    self.first? or self.last?
  end

  def set_position
    unless last_status.nil?
      self.position = last_status.position + 1
    end
  end

  def first_status
    account.feature_statuses.ordered.first
  end

  def last_status
    account.feature_statuses.ordered.last
  end

  def check_and_update_default_status
    if default_status_available? and not @bypass and self.default
      update_default_status
      self.position = 1
    end
  end

  def update_position(direction)
    position = self.position

    if direction.eql? DIRECTION_UP
      changed_status = FeatureStatus.where(:position => position.to_i - 1).first
    elsif direction.eql? DIRECTION_DOWN
      changed_status = FeatureStatus.where(:position => position.to_i + 1).first
    end

    self.position = changed_status.position
    #logger.debug "Target position: " + self.position.to_s

    changed_status.position = position
    #logger.debug "Changed position: " + changed_status.position.to_s

    @bypass = true #We want to bypass the interceptor because there are two instance.save

    # Let's make sure first position is always the default status
    if self.position == 1
      self.default = true
    else
      self.default = false
    end

    if changed_status.position == 1
      changed_status.default = true
    else
      changed_status.default = false
    end

    self.save
    changed_status.save

    return self
  end

  private
    def default_status_available?
      @current_default = FeatureStatus.default

      not @current_default.nil? # reverse it
    end

    def update_default_status
      # Change the current default status to make sure there's only one default status
      @current_default.default = false
      @current_default.position = self.position

      @current_default.save
    end

end