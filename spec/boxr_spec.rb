require 'spec_helper'

describe Boxr do

	#PLEASE NOTE: This test is intentionally NOT a series of unit tests.  The goal is to test the entire code base
	# 						against an actual Box account, making real calls to the Box API.  The Box API is subject to frequent
	# 						changes and it is not sufficient to mock responses as those responses will change over time.  Successfully
	# 						running this test suite shows that the code base works with the current Box API.

	#follow the directions in .env.example to set up your BOX_DEVELOPER_TOKEN
	#keep in mind it is only valid for 60 minutes
	BOX_CLIENT = Boxr::Client.new(ENV['BOX_DEVELOPER_TOKEN'])
	
	#uncomment this line to see the HTTP request and response debug info in the rspec output
	#BOX_CLIENT.debug_device = STDOUT

	TEST_FOLDER_NAME = 'Boxr_Test'
	SUB_FOLDER_NAME = 'sub_folder_1'
	SUB_FOLDER_DESCRIPTION = 'This was created by the Boxr test suite'

	it 'smoke tests the code base against a real Box account' do

	  puts "delete pre-existing test folder if found and create a new test folder"
		root_folders = BOX_CLIENT.folder_items(Boxr::ROOT).folders
		test_folder = root_folders.select{|f| f.name == TEST_FOLDER_NAME}.first
		if(test_folder)
			BOX_CLIENT.delete_folder(test_folder.id, recursive: true)
		end

		puts "create a new, empty test folder"
		new_folder = BOX_CLIENT.create_folder(TEST_FOLDER_NAME, Boxr::ROOT)
		expect(new_folder).to be_a Hashie::Mash

		test_folder_id = nil
		puts 'look up test folder id'
		test_folder_id = BOX_CLIENT.folder_id(TEST_FOLDER_NAME)
		expect(test_folder_id).to be_a String

		sub_folder_id = nil
		puts 'create a new sub-folder'
		new_folder = BOX_CLIENT.create_folder(SUB_FOLDER_NAME, test_folder_id)
		expect(new_folder).to be_a Hashie::Mash
		sub_folder_id = new_folder.id

		puts "update the sub-folder's description"
		updated_folder = BOX_CLIENT.update_folder_info(sub_folder_id, description: SUB_FOLDER_DESCRIPTION)
		expect(updated_folder.description).to eq(SUB_FOLDER_DESCRIPTION)

		puts "copy the sub-folder"
		new_folder = BOX_CLIENT.copy_folder(sub_folder_id,test_folder_id, name: 'copy of sub_folder_1')
		expect(new_folder).to be_a Hashie::Mash

		puts "create shared link for folder"
		updated_folder = BOX_CLIENT.create_shared_link_for_folder(test_folder_id)
		expect(updated_folder.shared_link).to be_a Hashie::Mash

		puts "disable shared link for folder"
		updated_folder = BOX_CLIENT.disable_shared_link_for_folder(test_folder_id)
		expect(updated_folder.shared_link).to be_nil


	end
end