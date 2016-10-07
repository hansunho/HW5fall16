# Completed step definitions for basic features: AddMovie, ViewDetails, EditMovie 

Given /^I am on the RottenPotatoes home page$/ do
  visit movies_path
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
  expect(result).to be_truthy
 end

 When /^I have visited the Details about "(.*?)" page$/ do |title|
   visit movies_path
   click_on "More about #{title}"
 end

 Then /^(?:|I )should see "([^"]*)" $/ do |text|
    expect(page).to have_content(text)
 end


 When /^I have edited the movie "(.*?)" to change the rating to "(.*?)"$/ do |movie, rating|
  click_on "Edit"
  select rating, :from => 'Rating'
  click_button 'Update Movie Info'
 end


# New step definitions to be completed for HW5. 
# Note that you may need to add additional step definitions beyond these


# Add a declarative step here for populating the DB with movies.

Given /the following movies have been added to RottenPotatoes:/ do |movies_table|
  movies_table.hashes.each do |movie|
    
    film = Movie.new()
    film.title = movie[:title]
    film.rating =  movie[:rating]
    film.release_date =  movie[:release_date]
    film.save()
    # Each returned movie will be a hash representing one row of the movies_table
    # The keys will be the table headers and the values will be the row contents.
    # Entries can be directly to the database with ActiveRecord methods
    # Add the necessary Active Record call(s) to populate the database.
  end
end

When /^I have opted to see movies rated: "(.*?)"$/ do |arg1|
 all('input[type=checkbox]').each do |checkbox|
        if checkbox.checked? == "checked" then 
            uncheck (checkbox[:id])
        end
    end

    arg1.split(", ").each do |r|
    check ("ratings_"+r)
    end
      click_button 'Refresh'

end

Then /^I should see only movies rated: "(.*?)"$/ do |arg1|
      args = arg1.split(", ")

  all('table#movies tbody tr').each do |movie|
      if (!args.include? (movie.all('td')[1].text )) then
      fail(msg = "Error: #{movie.all('td')[0].text} has a rating of #{movie.all('td')[1].text}")
    end
   end  
    
    
end

Then /^I should see all of the movies$/ do
   page.should have_selector('table tbody tr', :count => Movie.count )
end

Then(/^I should see "(.*?)"$/) do |arg1|
    page.should have_content(arg1)
end

When(/^I sort movies alphabetically$/) do
find_by_id("title_header").click
end

Then(/^I should see movies in alphabetical order$/) do
    count = Movie.count - 1
    i=0
    while i < count do
        if  !(all('table#movies tbody tr')[i].all('td')[0].text.to_s < all('table#movies tbody tr')[i+1].all('td')[0].text.to_s)
            then 
                  fail(msg = "Error: #{all('table#movies tbody tr')[i].all('td')[0].text} came before #{ all('table#movies tbody tr')[i+1].all('td')[0].text}")
        end
        i += 1
    end

end

When(/^I sort movies by increasing order of release date$/) do
find_by_id("release_date_header").click
end

Then(/^I should see movies in increasing order of release date$/) do
   count = Movie.count - 1
    i=0
    while i < count do
        if  !(all('table#movies tbody tr')[i].all('td')[2].text < all('table#movies tbody tr')[i+1].all('td')[2].text)
            then 
                  fail(msg = "Error: #{all('table#movies tbody tr')[i].all('td')[2].text} came before #{ all('table#movies tbody tr')[i+1].all('td')[2].text}")
        end
        i += 1
    end
end
