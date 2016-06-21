require 'integration_test_helper'

class TaggingToLinkablesTest < JavascriptIntegrationTest
  setup do
    setup_users
    stub_linkables
  end

  test "Tagging to browse pages" do
    edition = FactoryGirl.create(:guide_edition)
    content_id = edition.artefact.content_id

    stub_no_links(content_id)

    visit edition_path(edition)
    switch_tab 'Tagging'
    selectize ['Tax / VAT', 'Tax / RTI (draft)'], 'Mainstream browse pages'

    save_tags_and_assert_success
    assert_publishing_api_patch_links(content_id)
  end

  test "Tagging to topics" do
    edition = FactoryGirl.create(:guide_edition)

    visit edition_path(edition)

    select 'Oil and Gas / Wells', from: 'Primary topic'
    select 'Oil and Gas / Fields', from: 'Additional topics'
    select 'Oil and Gas / Distillation (draft)', from: 'Additional topics'

    save_edition_and_assert_success
    edition.reload

    assert_equal 'oil-and-gas/wells', edition.primary_topic
    assert_equal ['oil-and-gas/distillation', 'oil-and-gas/fields'], edition.additional_topics
  end

  test "Mistagging primary and additional topics with the same tag" do
    edition = FactoryGirl.create(:guide_edition)
    visit edition_path(edition)

    select 'Oil and Gas / Wells', from: 'Primary topic'
    select 'Oil and Gas / Wells', from: 'Additional topics'
    select 'Oil and Gas / Distillation (draft)', from: 'Additional topics'

    save_edition_and_assert_error

    assert page.has_css?('#edition_additional_topics_input.has-error')
    assert page.has_content?("can't have the primary topic set as an additional topic")
  end
end
