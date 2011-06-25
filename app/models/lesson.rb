class Lesson < ActiveRecord::Base
  # Validations
  validates :name, :length => { :maximum => 255 }, :presence => true
  validates :sequence, :presence => true
  validates :sequence, :allow_nil => true, :allow_blank => true,
    :numericality => { :greater_than => 0, :only_integer => true }
  
  # Relations
  has_many :slides, :dependent => :destroy,
    :order => "#{Slide.table_name}.number ASC"
  
  def to_s
    self.name
  end
end