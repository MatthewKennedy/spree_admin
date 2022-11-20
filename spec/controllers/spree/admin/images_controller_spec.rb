require "spec_helper"

module Spree
  module Admin
    describe ImagesController, type: :controller do
      stub_authorization!

      let(:store) { Spree::Store.default }
      let(:product) { create(:product, stores: [store]) }
      let(:product_in_other_store) { create(:product, stores: [create(:store)]) }

      describe "#destroy" do
        context "when request format is turbo_stream" do
          subject(:send_request) do
            delete :destroy, params: {product_id: product, id: image, format: :turbo_stream}
          end

          let(:image) { create(:image, viewable: product.master) }

          shared_examples "correct response" do
            it { expect(assigns(:image)).to eq(image) }
            it { expect(response).to have_http_status(:ok) }
          end

          context "will successfully destroy image" do
            describe "returns response" do
              before { send_request }

              it_behaves_like "correct response"

              it { expect(flash[:message]).to be_nil }
            end
          end

          context "can destroy image belonging to a variant not master_variant" do
            let(:variant) { create(:variant) }
            let(:product) { variant.product }
            let(:image) { create(:image, viewable: variant) }

            before do
              product.update(stores: [store])
              product.save
              product.reload
            end

            it do
              send_request
              expect(flash[:message]).not_to eq("Image is not found")
              expect(flash[:message]).to be_nil
            end
          end

          context "can not destroy image belonging to a variant not master_variant but also belongs to other store" do
            let(:variant) { create(:variant) }
            let(:product) { variant.product }
            let(:image) { create(:image, viewable: variant) }

            before do
              product.update(stores: [create(:store)])
              product.save
              product.reload
            end

            it do
              send_request
              expect(flash[:kind]).to eq(:error)
              expect(flash[:message]).to eq("Image is not found")
            end
          end

          context "cannot destroy image of product from different store" do
            let(:product) { create(:product, stores: [create(:store)]) }
            before { send_request }

            it do
              expect(send_request).to redirect_to(spree.admin_product_images_path(product))
              expect(flash[:kind]).to eq(:error)
              expect(flash[:message]).to eq("Image is not found")
            end
          end
        end

        context "when request format is html" do
          subject(:send_request) do
            delete :destroy, params: {product_id: product, id: image, format: :html}
          end

          let(:image) { create(:image, viewable: product.master) }

          shared_examples "correct response" do
            it { expect(assigns(:image)).to eq(image) }
            it { expect(response).to have_http_status(:ok) }
          end

          context "will successfully destroy image" do
            describe "returns response" do
              before { send_request }

              it { expect(send_request).to redirect_to(spree.admin_product_images_path(product)) }
            end
          end

          context "can destroy image belonging to a variant not master_variant" do
            let(:variant) { create(:variant) }
            let(:product) { variant.product }
            let(:image) { create(:image, viewable: variant) }

            before do
              product.update(stores: [store])
              product.save
              product.reload
            end

            it do
              send_request

              expect(flash[:kind]).to eq(:success)
              expect(flash[:message]).to eq("Image has been successfully removed!")
              expect(send_request).to redirect_to(spree.admin_product_images_path(product))
            end
          end

          context "can not destroy image belonging to a variant not master_variant but also belongs to other store" do
            let(:variant) { create(:variant) }
            let(:product) { variant.product }
            let(:image) { create(:image, viewable: variant) }

            before do
              product.update(stores: [create(:store)])
              product.save
              product.reload
            end

            it do
              send_request

              expect(flash[:kind]).to eq(:error)
              expect(flash[:message]).to eq("Image is not found")
            end
          end

          context "cannot destroy image of product from different store" do
            let(:product) { create(:product, stores: [create(:store)]) }

            before { send_request }

            it do
              expect(send_request).to redirect_to(spree.admin_product_images_path(product))

              expect(flash[:kind]).to eq(:error)
              expect(flash[:message]).to eq("Image is not found")
            end
          end
        end
      end
    end
  end
end
