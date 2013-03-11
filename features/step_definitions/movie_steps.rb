# Completed step definitions for basic features: AddMovie, ViewDetails, EditMovie 

Given /^I am on the RottenPotatoes home page$/ do
  visit movies_path
 end

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  assert page.body =~ /#{e1}.*#{e2}/m
end

 When /^I have added a movie with title "(.*?)" and rating "(.*?)"$/ do |title, rating|
  visit new_movie_path
  fill_in 'Title', :with => title
  select rating, :from => 'Rating'
  click_button 'Save Changes'
 end

 Then /^I should see a movie list entry with title "(.*?)" and rating "(.*?)"$/ do |title, rating| 
   result=false
   all("tr").each do |tr|
     if tr.has_content?(title) && tr.has_content?(rating)
       result = true
       break
     end
   end
   assert result
 end

 When /^I have visited the Details about "(.*?)" page$/ do |title|
   visit movies_path
   click_on "More about #{title}"
 end

Then /^(?:|I )should see "([^"]*)"$/ do |text|
  if page.respond_to? :should
    page.should have_content(text)
  else
    assert page.has_content?(text)
  end
end

 When /^I have edited the movie "(.*?)" to change the rating to "(.*?)"$/ do |movie, rating|
  click_on "Edit"
  select rating, :from => 'Rating'
  click_button 'Update Movie Info'
 end


# New step definitions to be completed for HW3. 
# Note that you may need to add additional step definitions beyond these


# Add a declarative step here for populating the DB with movies.

Given /the following movies have been added to RottenPotatoes:/ do |movies_table|
  movies_table.hashes.each do |movie|
    # Each returned movie will be a hash representing one row of the movies_table
    # The keys will be the table headers and the values will be the row contents.
    # You should arrange to add that movie to the database here.
    # You can add the entries directly to the databasse with ActiveRecord methodsQ
    Movie.create!(movie)
  end
end

When /^I have opted to see movies rated: "(.*?)"$/ do |rating_list|
  # HINT: use String#split to split up the rating_list, then
  # iterate over the ratings and check/uncheck the ratings
  # using the appropriate Capybara command(s)
  rating_list =rating_list.gsub(/[,]/,"")
  ratings = rating_list.split
  ratings.each do |r|
     check("ratings_#{r}")
    end
end

Then /^I should see only movies rated: "(.*?)"$/ do |selected_rating|
  selected_rating = selected_rating.gsub(/[,]/,"")
  rate = selected_rating.split
  rate.each do |ra|
    assert page.has_xpath?("//td[text()='#{ra}']")
 end
end

Then /^I should see PG and R movies$/ do
  assert page.has_xpath?("//td[text()='PG']")
  assert page.has_xpath?("//td[text()='R']")
end
Then /^I should see all of the movies$/ do
assert page.has_css?("table tbody tr", count: 10)
end

When /I sort the results by (.*)/ do |sort_order|
  sort_id = sort_order.gsub(/\s/, '_')
  click_link "#{sort_id}_header"
end

When /I follow "Movie Title"/ do
  click_link "title_header"
end

When /i follow "Release Date"/ do
  click_link "release_date_header"
end

