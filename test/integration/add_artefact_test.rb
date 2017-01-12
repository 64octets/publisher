require "integration_test_helper"

class AddArtefactTest < ActionDispatch::IntegrationTest
  setup do
    setup_users
  end

  should "create a new artefact" do
    visit root_path
    click_link "Add artefact"

    fill_in "Name", with: "Thingy McThingface"
    fill_in "Slug", with: "help/thingy-mc-thingface"
    select "Help page", from: "Kind"

    click_button "Save and go to item"

    assert page.has_content?("Thingy McThingface")
  end
end
