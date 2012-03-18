
post '/file' do
  if !params[:file] or !params[:file][:tempfile]
    status 400
    @mes = 'bad request'
  else
    begin
      data = params[:file][:tempfile].read
      fname = Digest::MD5.hexdigest data
      if params[:file][:filename] =~ /\./
        fname += '.'+params[:file][:filename].split('.').last.downcase
      end
      fpath = "#{data_dir}/#{fname}"
      unless File.exists? fpath
        f = File.open(fpath, 'w+')
        f.write data
        f.close
      end
      status 200
      @mes = "#{data_dir_url}/#{fname}"
    rescue => e
      STDERR.puts e
      status 500
      @mes = e
    end
  end
end
