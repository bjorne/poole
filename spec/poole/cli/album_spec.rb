require 'spec_helper'
module Poole
  module CLI
    describe Album do
      SANDBOX = Poole::App.albums_dir # set in spec_helper

      before(:each) do
        @pwd = Dir.pwd
        Dir.chdir(SANDBOX)
      end
      
      after(:each) do
        clean_albums
        Dir.chdir @pwd
      end
      
      describe "#create" do
        before(:each) do
          @album = Album.new
        end
        
        it "halts if directory exists" do
            FileUtils.mkdir("dummy")
            lambda { @album.invoke(:create, ["dummy"]) }.should raise_error(AlbumDirectoryExistsError)
        end

        it "does not halt if directory exists and --force is specified" do
          pending
        end

        it "signals success" do
          capture(:stdout) { @album.invoke(:create, ["dummy"]) }.should =~ /success/i
        end

        it "raises error if template directory does not exist" do
          App.should_receive(:album_template_dir).and_return("oops/does/not/exist")
          lambda { @album.invoke(:create, ["dummy"]) }.should raise_error(AlbumTemplateError)
        end
        
        it "creates the album directory" do
          @album.invoke(:create, ["dummy"])
          File.exists?("dummy").should be_true
        end

        it "copies template files" do
          @album.invoke(:create, ["dummy"])
          File.read("dummy/index.yml").should == File.read(File.join(App.album_template_dir, "index.yml"))
        end

        it "copies template subfolders" do
          @album.invoke(:create, ["dummy"])
          File.directory?("dummy/sub1").should be_true
          File.exists?("dummy/sub1/file.txt").should be_true
        end

        it "copies hidden template files" do
          @album.invoke(:create, ["dummy"])
          File.exists?("dummy/sub2/.gitkeep").should be_true
        end

        it "touches the YAML file" do
          @album.invoke(:create, ["dummy"])
          File.exists?("dummy/#{Poole::Album::YAML_CONFIG}").should be_true
        end
        
        it "fills in the title"
        it "defaults to DEFAULT_TITLE for title"

      end
    end
    
  end
end
