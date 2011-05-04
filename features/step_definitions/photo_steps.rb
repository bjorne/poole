Then /^I should see a photo thumbnail "([^\"]*)"$/ do |filename|
  with_scope("#album_photos") do
    page.should have_selector(%Q{.thumb img[src*="#{filename}"]})
  end
end
