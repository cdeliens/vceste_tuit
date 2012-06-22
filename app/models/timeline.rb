class Timeline < ActiveRecord::Base
  after_create :lowercase
  validates :hashtag,
  :presence   => true,
  :format     => { :with => /#\S*/ }

  def to_param
    "#{hashtag.gsub("#", "")}".parameterize
  end
  
  def lowercase
  	self.hashtag = self.hashtag.downcase
  	save
  end


end
