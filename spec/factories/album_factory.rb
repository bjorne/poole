require 'yaml'

def create_album(opts)
  if (inside = opts.delete(:inside))
    Poole::Album.reset
    parent = Poole::Album.all_albums.find{ |a| a.title == inside}
    raise Poole::AlbumNotFoundException, "Expected album does not exist: parent: #{inside}" if parent.nil?
  else
    parent = Poole::Album.root
  end

  yaml = YAML::dump(opts)
  dir = File.expand_path(File.join(parent.dir, opts[:title].downcase.gsub(/ /, '_')))
  FileUtils.mkdir(dir)
  File.open(File.join(dir, "index.yml"), 'w') { |f| f.puts yaml }
  Poole::Album.new(File.join(dir, "index.yml"), parent)
end

def clean_albums
  FileUtils.rm_r(Dir[File.join(Poole::Album.albums_dir, '*')])
  Poole::Album.reset
end

