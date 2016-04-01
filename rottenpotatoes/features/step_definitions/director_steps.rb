Given /^the following movies exist:$/ do |movie_table|
  movie_table.hashes.each do |movie_entry|
    Movie.create movie_entry
  end
end

Then /^the ([^"]*) of "([^"]*)" should be "([^"]*)"/ do |field, entry, value|
    movie_entry = Movie.find_by_title(entry)
    movie_entry[field].should == value
end
