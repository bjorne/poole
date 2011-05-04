require 'yaml'

def create_album(opts)
  photos = opts.delete(:photos)
  
  if (inside = opts.delete(:inside))
    Poole::Album.reset
    parent = Poole::Album.all_albums.find{ |a| a.title == inside}
    raise Poole::AlbumNotFoundException, "Expected album does not exist: parent: #{inside}" if parent.nil?
  else
    parent = Poole::Album.root
  end

  album = write_album(opts, parent)

  create_photos(album, photos) if photos
  album
end

def write_album(opts, parent)
  yaml = YAML::dump(opts)
  dir = File.expand_path(File.join(parent.dir, opts[:title].downcase.gsub(/ /, '_')))
  FileUtils.mkdir(dir) unless File.exists?(dir)
  File.open(File.join(dir, Poole::Album::YAML_CONFIG), 'w') { |f| f.puts yaml }
  Poole::Album.reset
  Poole::Album.new(File.join(dir, "index.yml"), parent)
end

def update_album_config(album, config)
  album.config.merge!(config)
  write_album(album.config, album.parent)
end

def create_photos(album, photos)
  photos.each do |photo|
    FileUtils.touch File.join(album.dir, photo)
  end
end

def clean_albums
  FileUtils.rm_r(Dir[File.join(Poole::Album.albums_dir, '*')])
  Poole::Album.reset
end

