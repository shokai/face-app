
post '/file' do
  if !params[:file] or !params[:file][:tempfile]
    status 400
    @mes = 'bad request'
  else
    begin
      data = params[:file][:tempfile].read
      md5 = Digest::MD5.hexdigest data
      unless b = FaceApp::Blob.find_by_md5(md5).first
        b = FaceApp::Blob.new(:md5 => md5,
                              :mime_type => params[:file][:type],
                              :ext => File.extname(params[:file][:filename]),
                              :size => data.size)
        b.save_file(data)
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
  unless b = FaceApp::Blob.find_by_md5(params[:hex_id]).first
    status 404
    @mes = "not found"
  else
    status 200
    @mes = "#{app_root}/#{b.file_path}"
  end
end
