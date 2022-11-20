module Spree
  module Admin
    class PaymentsController < Spree::Admin::BaseController
      include Spree::Backend::Callbacks
      include Spree::Admin::OrderConcern

      before_action :load_order
      before_action :load_payment, except: [:create, :new, :index]
      before_action :load_data
      before_action :can_not_transition_without_customer_info, except: [:show, :index]

      def index
        @payments = @order.payments.includes(refunds: :reason)
        @refunds = @payments.flat_map(&:refunds)
      end

      def new
        @payment_method = Spree::PaymentMethod.find(params[:payment_method_id])

        # Move order to payment state in order to capture tax generated on shipments
        @order.next if @order.can_go_to_state?("payment")
        @payment = @order.payments.build
      end

      def create
        invoke_callbacks(:create, :before)

        begin
          if @payment_method.store_credit?
            Spree::Dependencies.checkout_add_store_credit_service.constantize.call(order: @order)
            payments = @order.payments.store_credits.valid
          else
            @payment ||= @order.payments.build(object_params)
            if @payment.payment_method.source_required? && params[:card].present? && params[:card] != "new"
              @payment.source = @payment.payment_method.payment_source_class.find_by(id: params[:card])
            end
            @payment.save
            payments = [@payment]
          end

          if payments && (saved_payments = payments.select(&:persisted?)).any?
            invoke_callbacks(:create, :after)

            # Transition order as far as it will go.
            while @order.next; end
            # If "@order.next" didn't trigger payment processing already (e.g. if the order was
            # already complete) then trigger it manually now

            saved_payments.each { |payment| payment.process! if payment.reload.checkout? && @order.complete? }
            flash_message_for(saved_payments.first, :successfully_created)

            redirect_to spree.edit_admin_order_url(@order)
          else
            @payment ||= @order.payments.build(object_params)
            invoke_callbacks(:create, :fails)
            dispatch_notice(Spree.t(:payment_could_not_be_created), :error)

            render :new, status: :unprocessable_entity
          end
        rescue Spree::Core::GatewayError => e
          invoke_callbacks(:create, :fails)
          dispatch_notice(e.message.to_s, :error)

          redirect_to new_admin_order_payment_path(@order)
        end
      end

      def fire
        return unless (event = params[:e]) && @payment.payment_source

        # Because we have a transition method also called void, we do this to avoid conflicts.
        event = "void_transaction" if event == "void"
        if @payment.send("#{event}!")
          dispatch_notice(Spree.t(:payment_updated), :success)
        else
          dispatch_notice(Spree.t(:cannot_perform_operation), :error)
        end
      rescue Spree::Core::GatewayError => ge
        dispatch_notice(ge.message.to_s, :error)
      ensure
        redirect_to spree.admin_order_payments_path(@order)
      end

      private

      def object_params
        # standard:disable Style/AndOr
        # standard:disable Lint/AssignmentInCondition
        if params[:payment] and params[:payment_source] and source_params = params.delete(:payment_source)[params[:payment][:payment_method_id]]
          params[:payment][:source_attributes] = source_params
        end
        # standard:enable Style/AndOr
        # standard:enable Lint/AssignmentInCondition

        params.require(:payment).permit(permitted_payment_attributes)
      end

      def load_data
        @amount = params[:amount] || load_order.total
        @payment_methods = @order.collect_backend_payment_methods
        if @payment&.payment_method
          @payment_method = @payment.payment_method
        else
          @payment_method = @payment_methods.find { |payment_method| payment_method.id == params[:payment][:payment_method_id].to_i } if params[:payment]
          @payment_method ||= @payment_methods.first
        end
      end

      def load_payment
        @payment = @order.payments.find_by!(number: params[:id])
      end

      def model_class
        Spree::Payment
      end
    end
  end
end
