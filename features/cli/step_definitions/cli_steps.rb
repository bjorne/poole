require 'shellwords'

Given /^I am in the albums directory$/ do
  @current_dir = Poole::App.albums_dir
end

When /^I run the album create task with arguments "([^\"]*)"$/ do |arg_str|
  FileUtils.cd(@current_dir) do
    @output = capture(:stdout) do
    # Run thor task programmatically
      args = Shellwords::shellwords(arg_str)
      # puts "ARGS: #{args}"
      # puts "ARGS: #{arg_str}"

      a = Poole::CLI::Album.new #(args)
      a.invoke(:create, args)
      # Ensure @current_dir is honored
    end
  end

end

Then /^I should see output "([^\"]*)"$/ do |text|
  @output.should =~ /#{text}/
end

Then /^the directory "([^\"]*)" should be an album$/ do |dir|
  FileUtils.cd(@current_dir) do
    File.exist?("#{dir}/#{Poole::Album::YAML_CONFIG}").should be_true
  end
end

Then /^the album in "([^\"]*)" should have title "([^\"]*)"$/ do |dir, title|
  FileUtils.cd(@current_dir) do
    Album.new("#{dir}/#{Poole::Album::YAML_CONFIG}").should have_title(title)
  end
end

