class Timeline < ActiveRecord::Base
  validates :hashtag,
  :presence   => true,
  :format     => { :with => /#\S*/ }

  def to_param
    "#{hashtag.gsub("#", "")}".parameterize
  end
end
