# frozen_string_literal: true

Given('a valid api {string}') do |path|
  @path = path
end

When('this api is accessed throught tshield') do
  HTTParty.get(TShieldHelpers.tshield_url(@path))
end

Then('response should be saved in {string}') do |destiny|
  content = JSON.parse(RequestsHelpers.content_for(destiny))
  expect(content).to eq(UsersHelpers.users_content)
end

Then('response should be saved in directory {string}') do |directory|
  Dir.entries('./component_tests/requests/components').each do |entry|
    next if entry !~ /resources/

    expect(entry).to eql(directory)
  end
end
