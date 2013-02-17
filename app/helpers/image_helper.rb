module ImageHelper

  def photo_credit(image, options={})
    if image.photographer
      name = (options[:link] ?
              link_to(image.photographer.name,
                      images_site_staff_path(image.photographer)) :
              image.photographer.name)
      if image.attribution.blank?
        name
      else
        image.attribution.sub('?', name)
      end.html_safe
    elsif image.credit
      image.credit
    end
  end

end