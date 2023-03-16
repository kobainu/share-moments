class ImageUploader < CarrierWave::Uploader::Base
  attr_accessor :camera, :lens_model, :iso_speed_ratings, :exposure_time, :f_number, :exposure_bias_value, :focal_length, :date_time_original, :latitude, :longitude

  if Rails.env.production?
    storage :fog
  else
    storage :file
  end

  process :get_exif_info
  def get_exif_info
    require 'exifr/jpeg'
    exif = EXIFR::JPEG.new(file.file).exif
    @camera = exif.model
    @lens_model = exif.lens_model
    @iso_speed_ratings = exif.iso_speed_ratings.to_i
    @exposure_time = exif.exposure_time.to_s
    @f_number = exif.f_number.to_f
    @exposure_bias_value = exif.exposure_bias_value
    @focal_length = exif.focal_length.to_i
    @date_time_original = exif.date_time_original
    if exif.gps.present?
      @latitude = exif.gps.latitude
      @longitude = exif.gps.longitude
    end
  end

  def store_dir
    if Rails.env.test?
      "uploads_#{Rails.env}/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    else
      "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    end
  end
end
