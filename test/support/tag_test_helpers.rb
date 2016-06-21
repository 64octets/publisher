require 'gds_api/test_helpers/publishing_api_v2'

module TagTestHelpers
  include GdsApi::TestHelpers::PublishingApiV2

  def stub_linkables
    publishing_api_has_linkables([
      { base_path: '/browse/tax/vat', internal_name: 'Tax / VAT', publication_state: 'published', content_id: 'CONTENT-ID-VAT' },
      { base_path: '/browse/tax/capital-gains', internal_name: 'Tax / Capital Gains Tax', publication_state: 'published', content_id: 'CONTENT-ID-CAPITAL' },
      { base_path: '/browse/tax/rti', internal_name: 'Tax / RTI', publication_state: 'draft', content_id: 'CONTENT-ID-RTI' },
    ], document_type: "mainstream_browse_page")

    publishing_api_has_linkables([
      { base_path: '/topic/oil-and-gas/wells', internal_name: 'Oil and Gas / Wells', publication_state: 'published', content_id: 'CONTENT-ID-WELLS' },
      { base_path: '/topic/oil-and-gas/fields', internal_name: 'Oil and Gas / Fields', publication_state: 'published', content_id: 'CONTENT-ID-FIELDS' },
      { base_path: '/topic/oil-and-gas/distillation', internal_name: 'Oil and Gas / Distillation', publication_state: 'draft', content_id: 'CONTENT-ID-DISTILL' },
    ], document_type: "topic")
  end

  def stub_no_links(content_id)
    publishing_api_has_links(
      "content_id" => content_id,
      "links" => {},
    )
  end
end
