
post '/file' do
  if !params[:file] or !params[:file][:tempfile]
    status 400
    @mes = 'bad request'
  else
    begin
      data = params[:file][:tempfile].read
      md5 = Digest::MD5.hexdigest data
      fam = FaceApp::Message.new(:md5 => md5,
                                 :from => params[:from],
                                 :description => params[:description])
      fam.save
      unless b = FaceApp::Blob.find_by_md5(md5)
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
      @mes = e.to_s
    end
  end
end

get '/md5/:md5' do
  unless b = FaceApp::Blob.find_by_md5(params[:md5])
    status 404
    @mes = "not found"
  else
    status 200
    @mes = "#{app_root}/#{b.file_path}"
  end
end

post '/md5' do
  if !params[:md5]
    status 400
    @mes = 'bad request'
  else
    begin
      unless b = FaceApp::Blob.find_by_md5(params[:md5])
        status 404
        @mes = 'not found'
      else
        fam = FaceApp::Message.new(:md5 => params[:md5],
                                   :from => params[:from],
                                   :description => params[:description])
        fam.save
        status 200
        @mes = "#{app_root}/#{b.file_path}"
      end
    rescue => e
      status 500
      STDERR.puts e
      @mes = e.to_s
    end
  end
end
