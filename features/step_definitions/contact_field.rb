Given(/^there is a contact_field named "(.*?)" in database$/) do |name|
  ContactField.new(:name => name).save!
end

Then(/^there shouldn't be any contact_field$/) do
  ContactField.all.count.should == 0
end
