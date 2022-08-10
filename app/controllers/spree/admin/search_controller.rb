module Spree
  module Admin
    class SearchController < Spree::Admin::BaseController
      def new
      end

      def search
        if params[:global_search_input].present? && params[:global_search_input].length > 2
          @search_result_products   = current_store.products.ransack(name_i_cont: params[:global_search_input]).result(distinct: true).limit(8)
          @search_result_taxons     = current_store.taxons.ransack(name_i_cont: params[:global_search_input]).result.limit(8)
          @search_result_orders     = current_store.orders.ransack(number_or_email_i_cont: params[:global_search_input]).result(distinct: true).limit(8)
          @search_result_cms_pages  = current_store.cms_pages.ransack(title_i_cont: params[:global_search_input]).result(distinct: true).limit(8)

          # TODO
          # Find an efficient way to ransack users by email even though they are encrypted.
          # @user_list = Spree.user_class.all.load
          # @search_result_users = @user_list.ransack(email_i_cont: params[:global_search_input]).result(distinct: true).limit(8)
        else
          []
        end

        respond_to do |format|
          format.turbo_stream do
            render turbo_stream: [
              turbo_stream.update('search_results',
                                  partial: 'spree/admin/shared/global_search/results',
                                  locals: { products: @search_result_products, taxons: @search_result_taxons, cms_pages: @search_result_cms_pages,
                                            orders: @search_result_orders, users: @search_result_users })
            ]
          end
        end
      end
    end
  end
end
