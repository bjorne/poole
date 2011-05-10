require 'thor'

module Poole
  module CLI
    class Album < Thor
      DEFAULT_TITLE = "Unnamed Album"
      namespace :album
      
      desc "create ALBUM_DIR [TITLE]", "Create an album in ALBUM_DIR with TITLE"
      def create(album_dir, title = DEFAULT_TITLE)
        if File.exists?(album_dir)
          raise AlbumDirectoryExistsError, "Directory exists: #{album_dir}. Aborting."
        end

        unless File.directory?(App.album_template_dir)
          raise AlbumTemplateError, "Album template directory could not be found. Aborting."
        end
        
        FileUtils.mkdir(album_dir)
        FileUtils.cp_r(Dir.glob(File.join(App.album_template_dir, "*")), album_dir)

        puts "Successfully created album in '#{album_dir}'."
      # rescue ThorAlbumError => msg
      #   $stderr.puts "An error occured:\n#{msg}"
      end
    end
    
    class ThorAlbumError < Exception; end
    class AlbumDirectoryExistsError < ThorAlbumError; end
    class AlbumTemplateError < ThorAlbumError; end
  end
end
