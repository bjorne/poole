module Poole
  class Photo
    attr_accessor :filename, :album

    def initialize(filename, album)
      @filename = filename
      @album = album
    end

    def src_path(size = nil)
      if size.nil?
        album.path + '/' + filename
      elsif App.image_dirs[size]
        album.path + '/' + App.image_dirs[size] + '/' + filename
      end
    end

    def thumbnail_path
      
    end
  end
end
