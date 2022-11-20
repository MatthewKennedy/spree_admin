require "spec_helper"

module Spree
  module Admin
    describe VariantsController, type: :controller do
      stub_authorization!

      let(:store) { Spree::Store.default }
      let(:product) { create(:product, stores: [store]) }

      describe "#destroy" do
        subject(:send_request) do
          delete :destroy, params: {product_id: product, id: variant, format: :turbo_stream}
        end

        let(:variant) { create(:variant, product: product) }

        shared_examples "correct response" do
          it { expect(assigns(:variant)).to eq(variant) }
          it { expect(response).to have_http_status(:ok) }
        end

        context "will successfully destroy variant" do
          describe "returns response" do
            before { send_request }

            it_behaves_like "correct response"
            it do
              expect(flash[:kind]).to eq(:success)
              expect(flash[:message]).to be_nil
            end
          end
        end

        context "cannot destroy variant of other product" do
          let(:other_product) { create(:product, stores: [store]) }
          let(:variant) { create(:variant, product: other_product) }

          it do
            send_request

            expect(flash[:kind]).to eq(:error)
            expect(flash[:message]).to eq("Variant is not found")
          end
        end

        xcontext "cannot destroy variant of product from different store" do
          let(:product) { create(:product, stores: [create(:store)]) }

          it { expect { send_request }.to raise_error(ActiveRecord::RecordNotFound) }
        end
      end
    end
  end
end
