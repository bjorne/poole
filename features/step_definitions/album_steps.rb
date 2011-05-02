Given /there is an album with title "([^\"]*)"$/ do |title|
  Given("there is an album with title \"#{title}\" in the root")
end

Given /there is an album with title "([^\"]*)" in( the root|side)( "([^\"]+)")?$/ do |title, what, dummy, where|
  if what =~ /root/ # root album
    create_album(:title => title)
  else # inside <some album>
    create_album(:title => title, :inside => where)
  end
end
