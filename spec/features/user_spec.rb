require 'spec_helper'
include UserHelper

feature 'Create User Form' do
	it "should show a user create form" do
		visit new_user_path
		page.should have_content "Handle"
	end
end

feature 'Create User' do
	it "should save to database" do
		visit new_user_path
		expect {
			fill_in 'user_handle', with: 'username'
			fill_in 'user_email', with: "email@email.com"
			fill_in 'user_password', with: "password"
			fill_in 'user_password_confirmation', with: "password"
			click_button 'Create User'
		}.to change(User, :count).by(1)
	end
end


feature "Visit Profile" do
	before(:each) do
		@user = User.create!(:handle => "Test1", :email => "a@b.com", :password => "abc123", :password_confirmation=> "abc123")
	end
	it "be able to visit the profile" do
		visit user_path(@user.id)

		page.should have_content "Profile"
	end

	it "be able to click on all questions and get all user questions" do
		visit user_path(@user.id)
		click_link('All user questions')

		page.should have_content('All Questions')
	end

	it "be able to click on all answers and get all user answers" do
		visit user_path(@user.id)
		click_link('All user answers')

		page.should have_content('All Answers')
	end
end

feature 'User Profile' do
	before(:each) do
		sign_in
		click_link 'Profile'
	end

	context 'with Editing' do
		it "should see Edit Profile link in Profile Page" do
			page.should have_content 'Edit Profile'
		end

		it "should change handle" do 
			click_link 'Edit Profile'
			fill_in 'user_handle', with: 'handle2'
			click_button 'Edit User'
			visit logout_path
			visit login_path
			fill_in 'session_handle', with: 'handle2'
			fill_in 'session_password', with: 'password'
			click_button 'Login'
			page.should have_content 'Profile'
		end
	end
end