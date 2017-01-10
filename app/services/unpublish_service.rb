class UnpublishService
  class << self
    def call(artefact, user, redirect_url = "")
      return false if archived?(artefact)

      update_artefact_in_shared_db artefact, user, redirect_url
      remove_from_rummager_search artefact
      add_gone_route_in_router_api artefact
      unpublish_in_publishing_api artefact
    end

  private

    def archived?(artefact)
      artefact.state == 'archived'
    end

    def update_artefact_in_shared_db(artefact, user, redirect_url)
      artefact.update_attributes_as(
        user,
        state: "archived",
        redirect_url: redirect_url
      )
    end

    def remove_from_rummager_search(artefact)
      RemoveFromSearch.call(artefact.slug)
    end

    def add_gone_route_in_router_api(artefact)
      RoutableArtefact.new(artefact).submit
    end

    def unpublish_in_publishing_api(artefact)
      Services.publishing_api.unpublish(
        artefact.content_id,
        type: 'gone',
        discard_drafts: true
      )
    end
  end
end
