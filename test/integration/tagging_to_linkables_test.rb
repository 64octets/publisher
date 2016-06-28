require 'integration_test_helper'

class TaggingToLinkablesTest < JavascriptIntegrationTest
  setup do
    setup_users
    stub_linkables

    @edition = FactoryGirl.create(:guide_edition)
    @content_id = @edition.artefact.content_id
  end

  test "Tagging to browse pages" do
    stub_no_links_for_all_content_ids

    visit edition_path(@edition)
    switch_tab 'Tagging'
    selectize ['Tax / VAT', 'Tax / RTI (draft)'], 'Mainstream browse pages'

    save_tags_and_assert_success
    assert_publishing_api_patch_links(
      @content_id,
      {
        links: {
          topics: [],
          mainstream_browse_pages: ["CONTENT-ID-VAT", "CONTENT-ID-RTI"],
          parent: [],
        },
        previous_version: 0
      }
    )
  end

  test "Tagging to topics" do
    stub_no_links_for_all_content_ids

    visit edition_path(@edition)
    switch_tab 'Tagging'

    select 'Oil and Gas / Fields', from: 'Topics'
    select 'Oil and Gas / Distillation (draft)', from: 'Topics'

    save_tags_and_assert_success
    assert_publishing_api_patch_links(
      @content_id,
      {
        links: {
          topics: ['CONTENT-ID-DISTILL', 'CONTENT-ID-FIELDS'],
          mainstream_browse_pages: [],
          parent: [],
        },
        previous_version: 0
      }
    )
  end

  test "Tagging to parent" do
    stub_no_links_for_all_content_ids

    visit edition_path(@edition)
    switch_tab 'Tagging'

    select 'Tax / RTI', from: 'Parent/Breadcrumb'

    save_tags_and_assert_success
    assert_publishing_api_patch_links(
      @content_id,
      {
        links: {
          topics: [],
          mainstream_browse_pages: [],
          parent: ['CONTENT-ID-RTI'],
        },
        previous_version: 0
      }
    )
  end

  test "Mutating existing tags" do
    publishing_api_has_links(
      "content_id" => @content_id,
      "links" => {
        topics: ['CONTENT-ID-WELLS'],
        mainstream_browse_pages: ['CONTENT-ID-RTI'],
        parent: ['CONTENT-ID-RTI'],
      },
    )

    visit edition_path(@edition)
    switch_tab 'Tagging'

    select 'Tax / Capital Gains Tax', from: 'Parent/Breadcrumb'
    selectize ['Tax / VAT', 'Tax / RTI'], 'Mainstream browse pages'
    select 'Oil and Gas / Fields', from: 'Topics'

    save_tags_and_assert_success

    assert_publishing_api_patch_links(
      @content_id,
      {
        links: {
          topics: ['CONTENT-ID-FIELDS', 'CONTENT-ID-WELLS'],
          mainstream_browse_pages: ['CONTENT-ID-VAT', 'CONTENT-ID-RTI'],
          parent: ['CONTENT-ID-CAPITAL'],
        },
        previous_version: 0
      }
    )
  end
end
