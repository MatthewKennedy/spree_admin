require "spec_helper"

RSpec.describe Spree::Admin::DigitalsController do
  include ActionDispatch::TestProcess::FixtureFile

  stub_authorization!

  let!(:product) { create(:product) }
  let(:file_upload) { fixture_file_upload(file_fixture("icon_512x512.png"), "image/png") }

  describe "#create" do
    context "for a product that exists" do
      let!(:variant) { create(:variant, product: product) }

      it "creates a digital associated with the variant and product" do
        expect do
          post :create, params: {product_id: product.slug,
                                 digital: {variant_id: variant.id,
                                           attachment: file_upload}}
          expect(response).to redirect_to(spree.edit_admin_product_variant_path(product, variant))
        end.to change(Spree::Digital, :count).by(1)
      end
    end
  end

  describe "#destroy" do
    let(:digital) { create(:digital) }
    let!(:variant) { create(:variant, product: product, digitals: [digital]) }

    context "for a digital and product that exist" do
      it "deletes the associated digital" do
        expect do
          delete :destroy, params: {product_id: product.slug, id: digital.id}
          expect(response).to redirect_to(spree.admin_product_digitals_path(product))
        end.to change(Spree::Digital, :count).by(-1)
      end
    end
  end
end
