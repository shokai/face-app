require 'digest/md5'

class Blob
  include Mongoid::Document
  field :uploaded_at, :type => Time, :default => lambda{Time.now}
  field :md5, :type => String, :allow_blank => false
  field :mime_type, :type => String, :allow_blank => false
  field :ext, :type => String, :default => nil

  def self.find_by_md5(md5)
    self.where(:md5 => md5)
  end

  def self.find_by_data(data)
    self.find_by_md5 Digest::MD5.hexdigest data
  end

  def file_name
    "#{md5}#{ext}"
  end

  def file_path
    "f/#{file_name}"
  end

  def file_fullpath
    "#{base_dir}/#{file_name}"
  end

  def self.base_dir
    @@data_dir ||= File.dirname(__FILE__)+'/../public/f'
  end

  def base_dir
    self.class.base_dir
  end
end