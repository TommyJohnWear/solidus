module Spree
  module Api
    class ReturnAuthorizationsController < Spree::Api::BaseController
      before_filter :load_order
      around_filter :lock_order, only: [:create, :update, :destroy, :add, :receive, :cancel]

      def create
        @return_authorization = @order.return_authorizations.build(return_authorization_params)
        authorize! :create, @return_authorization
        if @return_authorization.save
          respond_with(@return_authorization, status: 201, default_template: :show)
        else
          invalid_resource!(@return_authorization)
        end
      end

      def destroy
        @return_authorization = @order.return_authorizations.accessible_by(current_ability, :destroy).find(params[:id])
        @return_authorization.destroy
        respond_with(@return_authorization, status: 204)
      end

      def index
        authorize! :admin, ReturnAuthorization
        @return_authorizations = @order.return_authorizations.accessible_by(current_ability, :read).
                                 ransack(params[:q]).result.
                                 page(params[:page]).per(params[:per_page])
        respond_with(@return_authorizations)
      end

      def new
        authorize! :admin, ReturnAuthorization
      end

      def show
        authorize! :admin, ReturnAuthorization
        @return_authorization = @order.return_authorizations.accessible_by(current_ability, :read).find(params[:id])
        respond_with(@return_authorization)
      end

      def update
        @return_authorization = @order.return_authorizations.accessible_by(current_ability, :update).find(params[:id])
        if @return_authorization.update_attributes(return_authorization_params)
          respond_with(@return_authorization, default_template: :show)
        else
          invalid_resource!(@return_authorization)
        end
      end

      def receive
        @return_authorization = @order.return_authorizations.accessible_by(current_ability, :update).find(params[:id])
        if @return_authorization.receive
          respond_with @return_authorization, default_template: :show
        else
          invalid_resource!(@return_authorization)
        end
      end

      def cancel
        @return_authorization = @order.return_authorizations.accessible_by(current_ability, :update).find(params[:id])
        if @return_authorization.cancel
          respond_with @return_authorization, default_template: :show
        else
          invalid_resource!(@return_authorization)
        end
      end

      private

      def load_order
        @order ||= Spree::Order.find_by!(number: order_id)
        authorize! :read, @order
      end

      def return_authorization_params
        params.require(:return_authorization).permit(permitted_return_authorization_attributes)
      end
    end
  end
end
