
class File
  include Mongoid::Document
  field :time, :type => Time, :default => lambda{Time.now}
  field :mime_type, :type => String
  field :ext, :type => String, :default => nil
  field :data
end
