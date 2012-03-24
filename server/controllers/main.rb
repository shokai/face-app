before '/*' do
  @title = 'face-app'
end

get '/' do
  @page = (params[:page] || 1).to_i
  @per_page = (params[:per_page] || 20).to_i

  @blobs = FaceApp::Blob.desc(:uploaded_at).skip(@per_page*(@page-1)).limit(@per_page)
  haml :index
end
