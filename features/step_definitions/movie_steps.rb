# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create! movie
  end
end


# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.content  is the entire content of the page as a string.
  pos1 = page.body.index e1
  pos2 = page.body.index e2
  assert (pos1!=nil)&&(pos2!=nil)&&(pos1<pos2)
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

Given /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  requestedRatings = rating_list.split ","
  requestedRatings= requestedRatings.map{|elt| elt.strip}
  requestedRatings.each do |elt|
    if (uncheck) then
	uncheck("ratings_"+elt) 
    else 
	check("ratings_"+elt)
    end
  end
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
end

Then /^the "([^"]*)" checkbox_ should be checked$/ do |label|
    field_checked = find_field("ratings_" + label)['checked']
    assert field_checked
end

Then /^the "([^"]*)" checkbox_ should not be checked$/ do |label|
    field_checked = find_field("ratings_" + label)['checked']
    assert (!field_checked)
end

Then /^I should see all the movies rated: (.*)/ do |rating_list|
  requestedRatings = rating_list.split ","
  requestedRatings= requestedRatings.map{|elt| elt.strip}
  Movie.find_all_by_rating(requestedRatings).each do |elt|
    assert page.has_content?(elt.title)
  end
end

Then /^I should not see any movies rated: (.*)/ do |rating_list|
  requestedRatings = rating_list.split ","
  requestedRatings= requestedRatings.map{|elt| elt.strip}
  Movie.find_all_by_rating(requestedRatings).each do |elt|
    assert page.has_no_content?(elt.title)
  end
end

Then /^the director of "(.*)" should be "(.*)"$/ do |movie_name, director_name|
  assert Movie.find_by_title(movie_name).director == director_name
end

