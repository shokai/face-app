get '/rss' do
  @msgs = FaceApp::Message.desc(:uploaded_at).limit(40)
  content_type 'application/xml'
  rss = RSS::Maker.make('2.0') do |rss|
    rss.channel.about = "#{app_root}/rss"
    rss.channel.title = @title
    rss.channel.link = app_root
    rss.channel.description = @title
    rss.items.do_sort = true
    rss.items.max_size = @msgs.size
    
    @msgs.each{|m|
      i= rss.items.new_item
      i.title = m.description || "md5:#{m.md5}"
      url = "#{app_root}/#{m.blob.file_path}"
      i.link = url
      i.description = "<p>[#{m.blob.mime_type}] #{m.blob.size.to_3digits} bytes</p>"
      if m.blob.mime_type =~ /^image/
        i.description += "<p><a href=\"#{url}\"><img src=\"#{url}\"></a></p>"
      else
        i.description += "<p><a href=\"#{url}\">#{url}</a></p>"
      end
      i.date = m.uploaded_at
    }
  end
  rss.to_s
end
