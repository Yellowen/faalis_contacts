Given(/^there is a contact_details named "(.*?)" in database$/) do |name|
  ContactDetails.new(:name => name).save!
end

Then(/^there shouldn't be any contact_details$/) do
  ContactDetails.all.count.should == 0
end
