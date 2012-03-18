
def app_root
  "#{env['rack.url_scheme']}://#{env['HTTP_HOST']}#{env['SCRIPT_NAME']}"
end

def data_dir_name
  'f'
end

def data_dir
  path = File.dirname(__FILE__)+"/../public/#{data_dir_name}"
  FileUtils.mkdir_p path unless File.exists? path
  path
end

def data_dir_url
  "#{app_root}/#{data_dir_name}"
end
