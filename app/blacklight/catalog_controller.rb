# frozen_string_literal: true

class CatalogController < ApplicationController
  include Blacklight::Catalog
  include Blacklight::AccessControls::Catalog
  include Blacklight::DefaultComponentConfiguration
  include CollectionMembers

  # Applies access controls from the blacklight-access_controls gem
  before_action :enforce_show_permissions, only: :show

  # Devise does not control index (i.e. search) requests. Search results are limited to a user's access rights
  # via Blacklight::AccessControls::SearchBuilder.
  skip_authorize_resource only: :index

  helper LocalHelperBehavior, LayoutHelperBehavior

  Blacklight::IndexPresenter.thumbnail_presenter = ::ThumbnailPresenter

  self.search_service_class = ::SearchService

  configure_blacklight do |config|
    ## Configure blacklight-gallery
    config.view.gallery.partials = [:index_header, :index]
    config.view.masonry.partials = [:index]
    config.view.slideshow.partials = [:index]

    config.show.tile_source_field = :content_metadata_image_iiif_info_ssm
    config.show.partials.insert(1, :openseadragon)

    ## Class for sending and receiving requests from a search index
    # config.repository_class = Blacklight::Solr::Repository
    #
    ## Class for converting Blacklight's url parameters to into request parameters for the search index
    # config.search_builder_class = ::SearchBuilder
    #
    ## Model that maps search index responses to the blacklight response model
    # config.response_model = Blacklight::Solr::Response

    ## Default parameters to send to solr for all search-like requests. See also SearchBuilder#processed_parameters
    config.default_solr_params = {
      rows: 10
    }

    # solr path which will be added to solr base url before the other solr params.
    # config.solr_path = 'select'

    # items to show per page, each number in the array represent another option to choose from.
    # config.per_page = [10,20,50,100]

    ## Default parameters to send on single-document requests to Solr.
    #  These settings are the Blackligt defaults (see SearchHelper#solr_doc_params) or
    #  parameters included in the Blacklight-jetty document requestHandler.
    #
    # config.default_document_solr_params = {
    #  qt: 'document',
    #  ## These are hard-coded in the blacklight 'document' requestHandler
    #  # fl: '*',
    #  # rows: 1,
    #  # q: '{!term f=id v=$id}'
    # }

    config.index.title_field = 'title_tesim'
    config.show.title_field = 'title_tesim'

    config.show.document_presenter_class = ShowPresenter

    config.add_facet_field 'work_type_ssim', label: I18n.t('cho.field_label.work_type')
    config.add_facet_field 'collection_type_ssim', label: I18n.t('cho.field_label.collection_type')

    # @todo configuration of linked field indexing
    config.add_facet_field 'creator_role_ssim', label: I18n.t('cho.field_label.role')

    fields_excluded_from_metadata_list = %w[
      acknowledgments
      narrative
    ]

    # Store search field config, to allow for later sorting and aggregation
    search_field_options = []

    DataDictionary::Field.all.sort_by(&:created_at).each do |map_field| # where core fields true
      catalog_field = map_field.solr_search_field
      catalog_label = map_field.display_name || map_field.label.titleize
      catalog_helper = map_field.display_transformation == 'no_transformation' ? nil : map_field.display_transformation.to_sym

      unless fields_excluded_from_metadata_list.include?(map_field.label)
        config.add_index_field catalog_field, label: catalog_label, helper_method: catalog_helper
        config.add_show_field catalog_field, label: catalog_label, helper_method: catalog_helper
      end

      # Store search param configuration for core fields
      if map_field.core_field
        field_name = map_field.label
        field_solr_params = { qf: catalog_field,
                              pf: catalog_field }
        search_field_options << [field_name, field_solr_params]
      end

      if map_field.facet?
        config.add_facet_field map_field.facet_field, label: catalog_label, helper_method: catalog_helper
      end
    end

    # Add "All Fields" as first search option, which is an aggregate of all others
    config.add_search_field('all_fields', label: 'All Fields') do |field|
      all_names = search_field_options
        .map { |_label, solr_params| solr_params[:qf] }
        .join(' ')

      field.solr_parameters = {
        qf: "#{all_names} id",
        pf: 'title_tesim'
      }
    end

    # Add the rest of the search dimensions
    search_field_options.each do |field_name, field_solr_params|
      config.add_search_field(field_name) do |field| # append 92-94 to array
        # solr_parameters hash are sent to Solr as ordinary url query params.
        field.solr_parameters = field_solr_params.merge(
          'spellcheck.dictionary': field.label
        )
      end
    end

    # solr field configuration for search results/index views
    config.index.display_type_field = 'work_type_ssim'
    config.index.thumbnail_field = 'thumbnail_path_ss'

    # solr field configuration for document/show views
    config.show.display_type_field = 'internal_resource_ssim'
    config.show.thumbnail_field = 'thumbnail_path_ss'

    # solr fields that will be treated as facets by the blacklight application
    #   The ordering of the field names is the order of the display
    #
    # Setting a limit will trigger Blacklight's 'more' facet values link.
    # * If left unset, then all facet values returned by solr will be displayed.
    # * If set to an integer, then "f.somefield.facet.limit" will be added to
    # solr request, with actual solr request being +1 your configured limit --
    # you configure the number of items you actually want _displayed_ in a page.
    # * If set to 'true', then no additional parameters will be sent to solr,
    # but any 'sniffed' request limit parameters will be used for paging, with
    # paging at requested limit -1. Can sniff from facet.limit or
    # f.specific_field.facet.limit solr request params. This 'true' config
    # can be used if you set limits in :default_solr_params, or as defaults
    # on the solr side in the request handler itself. Request handler defaults
    # sniffing requires solr requests to be made with "echoParams=all", for
    # app code to actually have it echo'd back to see it.
    #
    # :show may be set to false if you don't want the facet to be drawn in the
    # facet bar
    #
    # set :index_range to true if you want the facet pagination view to have facet prefix-based navigation
    #  (useful when user clicks "more" on a large facet and wants to navigate alphabetically across a large
    #  set of results) index_range can be an array or range of prefixes that will be used to create the navigation
    #  (note: It is case sensitive when searching values)

    # config.add_facet_field 'pub_date', label: 'Publication Year', single: true
    # config.add_facet_field 'subject_topic_facet', label: 'Topic', limit: 20, index_range: 'A'..'Z'
    # config.add_facet_field 'language_facet', label: 'Language', limit: true
    # config.add_facet_field 'lc_1letter_facet', label: 'Call Number'
    # config.add_facet_field 'subject_geo_facet', label: 'Region'
    # config.add_facet_field 'subject_era_facet', label: 'Era'

    # config.add_facet_field 'example_pivot_field', label: 'Pivot Field', :pivot => ['format', 'language_facet']

    # config.add_facet_field 'example_query_facet_field', label: 'Publish Date', :query => {
    #    :years_5 => { label: 'within 5 Years', fq: "pub_date:[#{Time.zone.now.year - 5 } TO *]" },
    #    :years_10 => { label: 'within 10 Years', fq: "pub_date:[#{Time.zone.now.year - 10 } TO *]" },
    #    :years_25 => { label: 'within 25 Years', fq: "pub_date:[#{Time.zone.now.year - 25 } TO *]" }
    # }

    # Have BL send all facet field names to Solr, which has been the default
    # previously. Simply remove these lines if you'd rather use Solr request
    # handler defaults, or have no facets.
    config.add_facet_fields_to_solr_request!

    # solr fields to be displayed in the index (search results) view
    #   The ordering of the field names is the order of the display
    config.add_index_field 'work_type_ssim', label: I18n.t('cho.field_label.work_type')
    config.add_index_field 'workflow_ssim', label: I18n.t('cho.field_label.workflow')
    config.add_index_field 'collection_type_ssim', label: I18n.t('cho.field_label.collection_type')

    # solr fields to be displayed in the show (single result) view
    #   The ordering of the field names is the order of the display
    config.add_show_field 'work_type_ssim', label: I18n.t('cho.field_label.work_type')
    config.add_show_field 'workflow_ssim', label: I18n.t('cho.field_label.workflow')
    config.add_show_field 'collection_type_ssim', label: I18n.t('cho.field_label.collection_type')

    # "fielded" search configuration. Used by pulldown among other places.
    # For supported keys in hash, see rdoc for Blacklight::SearchFields
    #
    # Search fields will inherit the :qt solr request handler from
    # config[:default_solr_parameters], OR can specify a different one
    # with a :qt key/value. Below examples inherit, except for subject
    # that specifies the same :qt as default for our own internal
    # testing purposes.
    #
    # The :key is what will be used to identify this BL search field internally,
    # as well as in URLs -- so changing it after deployment may break bookmarked
    # urls.  A display label will be automatically calculated from the :key,
    # or can be specified manually to be different.

    # This one uses all the defaults set by the solr request handler. Which
    # solr request handler? The one set in config[:default_solr_parameters][:qt],
    # since we aren't specifying it otherwise.

    # Now we see how to over-ride Solr request handler defaults, in this
    # case for a BL "search field", which is really a dismax aggregate
    # of Solr search fields.

    # "sort results by" select (pulldown)
    # label in pulldown is followed by the name of the SOLR field to sort by and
    # whether the sort is ascending or descending (it must be asc or desc
    # except in the relevancy case).
    # config.add_sort_field 'score desc, pub_date_sort desc, title_sort asc', label: 'relevance'
    # config.add_sort_field 'pub_date_sort desc, title_sort asc', label: 'year'
    # config.add_sort_field 'author_sort asc, title_sort asc', label: 'author'
    # config.add_sort_field 'title_sort asc, pub_date_sort desc', label: 'title'

    # If there are more than this many search results, no spelling ("did you
    # mean") suggestion is offered.
    # config.spell_max = 5

    # Configuration for autocomplete suggestor
    # config.autocomplete_enabled = true
    # config.autocomplete_path = 'suggest'

    config.add_nav_action(:my_works, partial: 'blacklight/nav/my_works')
    config.add_nav_action(:my_collectionss, partial: 'blacklight/nav/my_collections')
  end

  private

    # @note Overrides search service initialization to pass in current_ability.
    # We should be able to remove this once Blacklight access controls supports version 7.
    def search_service
      search_service_class.new(
        config: blacklight_config,
        user_params: search_state.to_h,
        current_ability: current_ability
      )
    end
end
