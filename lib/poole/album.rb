require 'yaml'

module Poole
  class Album
    YAML_CONFIG = "index.yml"
    MISSING_TITLE = "Unnamed Album"
    EXTENSIONS = %w[jpg jpeg]
    
    attr_accessor :dir, :config, :parent, :photo_filenames
    @@albums = nil
    
    class << self
      attr_accessor :albums_dir
    end

    def initialize(dir, parent = nil)
      @parent = parent
      if dir == :root
        @dir = Album.albums_dir
        @config = {}
      else
        @dir = File.dirname(dir)
        @config = YAML::load_file(dir).symbolize_keys
      end
    end

    def self.path_for_size(size)
      App.image_dirs[size]
    end
    
    def photos
      @photos ||= photo_filenames.map do |f|
        Photo.new(f, self)
      end
    end
    
    def photo_filenames
      @photo_filenames ||= load_photo_filenames!
    end

    def load_photo_filenames!
      Dir[File.join(dir, "*.{#{EXTENSIONS.join(",")}}")].map { |f| File.basename(f) }
    end

    def children
      if ENV['RACK_ENV'] == "test"
        load_children!
      else
        @children ||= load_children!
      end
    end

    def load_children!
      Dir[File.expand_path(File.join(self.dir, "*/#{YAML_CONFIG}"))].map do |dir|
        Album.new(dir, self)
      end
    end

    def load_recursive(albums = [])
      albums.concat(children)
      children.each do |child|
        # @@albums << child
        albums.concat(child.load_recursive)
      end
      albums
    end
    
    def parents
      []
    end

    def path
      dir.sub(Album.albums_dir + "/", '')
    end

    def yaml_path
      File.join(@dir, YAML_CONFIG)
    end

    def title
      config[:title] || MISSING_TITLE
    end

    def description
      config[:description]
    end

    def ==(other)
      @dir == other.dir
    end

    def <=>(other)
      title <=> other.title if other.title
    end

    def to_s
      %Q[<Album title:"#{title}", path:"#{path}">]
    end
    
    # class methods

    def self.load_albums!
      Album.root.load_recursive
    end

    def self.all_albums
      @@albums ||= load_albums!
    end
       
    def self.root
      @@root ||= new(:root)
    end

    def self.find_by_path!(path)
      album = find_by_path(path)
      # TODO: Does this string need to be html safe?
      raise AlbumNotFoundException, "Album could not be found: #{path}" unless album
      album
    end
    
    def self.find_by_path(path)
      album = all_albums.find do |album|
        album.path == path
      end
    end
    
    def self.path_to_dir(path)
      File.expand_path(File.join(albums_dir, path))
    end

    # Used in tests
    def self.reset
      @@albums = nil
      @@root = nil
    end
  end

  class AlbumNotFoundException < Exception
  end
end
