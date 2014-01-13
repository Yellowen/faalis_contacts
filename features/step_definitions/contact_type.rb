Given(/^there is a contact_type named "(.*?)" in database$/) do |name|
  ContactType.new(:name => name).save!
end

Then(/^there shouldn't be any contact_type$/) do
  ContactType.all.count.should == 0
end
