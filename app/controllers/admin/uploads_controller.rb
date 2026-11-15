module Admin
  class UploadsController < BaseController
    def index
      @upload = Upload.new
      @page = paginate(Upload.with_attached_file.order(created_at: :desc), per: 24)
    end

    def create
      @upload = Upload.new(params.expect(upload: %i[ title file ]))
      if @upload.save
        redirect_to admin_uploads_path, notice: "Image uploaded. Copy its Markdown below."
      else
        @page = paginate(Upload.with_attached_file.order(created_at: :desc), per: 24)
        render :index, status: :unprocessable_entity
      end
    end

    def destroy
      Upload.find(params[:id]).destroy!
      redirect_to admin_uploads_path, notice: "Image deleted. Articles that still reference it will show a broken image.", status: :see_other
    end
  end
end
