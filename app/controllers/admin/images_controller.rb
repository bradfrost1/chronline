class Admin::ImagesController < Admin::BaseController

  def index
    @images = Image.page(params[:page]).order('created_at DESC')
  end

  def upload
  end

  def create
    @image = Image.new(params[:image])
    if @image.save
      render json: {files: @image.to_jq_upload}
    else
      render json: @image.errors, status: :unprocessable_entity
    end
  end

  def edit
    @image = Image.find(params[:id])
  end

  def update
    @image = update_image(Image.find(params[:id]))
    if @image.save
      redirect_to [:edit, :admin, @image]
    else
      render 'edit'
    end
  end

  def crop
    image = Image.find(params[:id])
    image.assign_attributes(params[:image], without_protection: true)
    image.original.reprocess!(image.crop_style.underscore.to_sym)
    flash[:success] = "#{image.crop_style} version was cropped."
    redirect_to [:edit, :admin, image]
  end

  def destroy
    image = Image.find(params[:id])
    success_message = "Image \"#{image.original_file_name}\" was deleted."
    image.destroy
    flash[:success] = success_message
    redirect_to admin_images_path
  end

  private

  def update_image(image)
    photographer_name = params[:image].delete(:photographer_id)
    image.assign_attributes(params[:image])
    if photographer_name.blank?
      image.photographer = nil
    else
      image.photographer = Photographer.find_or_create_by_name(photographer_name)
    end
    image
  end

end
