
post '/file' do
  if !params[:file] or !params[:file][:tempfile]
    status 400
    @mes = 'bad request'
  else
    begin
      data = params[:file][:tempfile].read
      md5 = Digest::MD5.hexdigest data
      unless b = Blob.find_by_md5(md5).first
        puts 'new'
        b = Blob.new(:ext => File.extname(params[:file][:filename]),
                     :mime_type => params[:file][:type],
                     :md5 => md5)
        Dir.mkdir b.base_dir unless File.exists? b.base_dir
        open(b.file_fullpath, 'w+') do |f|
          f.write data
        end
        b.save
      end
      status 200
      @mes = "#{app_root}/#{b.file_path}"
    rescue => e
      STDERR.puts e
      status 500
      @mes = e
    end
  end
end

get '/id/:hex_id' do
  unless b = Blob.find_by_md5(params[:hex_id]).first
    status 404
    @mes = "not found"
  else
    status 200
    @mes = "#{app_root}/#{b.file_path}"
  end
end
