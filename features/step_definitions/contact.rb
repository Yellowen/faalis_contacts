Given(/^there is a contact named "(.*?)" in database$/) do |name|
  Contact.new(:name => name).save!
end

Then(/^there shouldn't be any contact$/) do
  Contact.all.count.should == 0
end
