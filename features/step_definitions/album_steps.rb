Given /there is an album "([^\"]*)"$/ do |title|
  Given("there is an album \"#{title}\" in the root")
end

Given /there is an album "([^\"]*)" in( the root|side)( "([^\"]+)")?$/ do |title, what, dummy, where|
  if what =~ /root/ # root album
    @album = create_album(:title => title)
  else # inside <some album>
    @album = create_album(:title => title, :inside => where)
  end
end

Given /the album has description:? "([^\"]*)"$/ do |desc|
  update_album_config(@album, :description => desc)
end

Given /^the album has (\d+) photos$/ do |num_photos|
  create_photos(@album, (1..num_photos.to_i).map { |n| "DSC_#{n}.jpg" })
end

