module Spree
  module Admin
    class PrototypesController < ResourceController
      def show
        redirect_to spree.admin_prototypes_path
      end
    end
  end
end
