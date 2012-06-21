class Timeline < ActiveRecord::Base
  validates :hashtag,
  :presence   => true,
  :format     => { :with => /#\S*/ }
end
