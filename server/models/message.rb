
module FaceApp
  class Message
    include Mongoid::Document
    field :md5, :type => String, :allow_blank => false
    field :description, :type => String, :default => nil
    field :uploaded_at, :type => Time, :default => lambda{Time.now}
    field :from, :type => String

    def blob
      @blob ||= Blob.find_by_md5(self.md5)
    end

    def self.find_by_md5(md5_hash)
      self.where(:md5 => md5_hash)
    end
  end
end
