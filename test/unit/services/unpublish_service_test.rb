require 'test_helper'

class UnpublishServiceTest < ActiveSupport::TestCase
  setup do
    @content_id = 'foo'
    @artefact = stub(update_attributes_as: true, content_id: @content_id, slug: "foo", state: "live")
    @user = stub
    @publishing_api = stub(unpublish: true)
    @router_api = stub(:submit)

    RemoveFromSearch.stubs(:call)
    RoutableArtefact.stubs(:new).returns(@router_api)
    Services.stubs(:publishing_api).returns(@publishing_api)
  end

  test "archives the artefact" do
    @artefact.expects(:update_attributes_as)
      .with(@user, state: 'archived', redirect_url: "")
      .returns(true)

    UnpublishService.call(@artefact, @user)
  end

  test "removes the artefact from Rummager search" do
    RemoveFromSearch.expects(:call).with(@artefact.slug)
    UnpublishService.call(@artefact, @user)
  end

  test "adds gone route to router_api" do
    @router_api.expects(:submit)

    UnpublishService.call(@artefact, @user)
  end

  test "tells the publishing API about the change" do
    @publishing_api.expects(:unpublish)
      .with(@content_id, type: 'gone', discard_drafts: true)
      .returns(true)

    UnpublishService.call(@artefact, @user)
  end

  test "returns false early if the artefact is already archived" do
    @artefact.expects(:state).returns("archived")
    @artefact.expects(:update_attributes_as).never
    RemoveFromSearch.expects(:call).never
    @router_api.expects(:submit).never
    @publishing_api.expects(:unpublish).never

    result = UnpublishService.call(@artefact, @user)
    assert result == false
  end

  test "allows a redirect_url to be passed in" do
    @artefact.expects(:update_attributes_as)
      .with(@user, state: 'archived', redirect_url: '/foo')
      .returns(true)

    UnpublishService.call(@artefact, @user, "/foo")
  end
end
