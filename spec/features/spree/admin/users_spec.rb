require "spec_helper"

describe "Users", type: :feature do
  stub_authorization!

  include Spree::BaseHelper
  include Spree::Admin::BaseHelper

  # zipcode required - no states and not required.
  # (TEST: Expect no state field to be present in the dom, zipcode field should have required attribute)
  let!(:united_kingdom) { create(:country, name: "United Kingdom", iso_name: "UNITED KINGDOM", iso3: "GBR", iso: "GB", states_required: false, zipcode_required: true) }

  # states are required and states are listed as select options.
  # (TEST: Expect states select with option but no blank option)
  let!(:australia) { create(:country, name: "Australia", iso_name: "AUSTRALIA", iso3: "AUS", iso: "AU", states_required: true, zipcode_required: true, states: create_list(:state, 6)) }

  # zipcode not required - states required but none listed.
  # (TEST: Expect a required attribute on a input field for state and zipcode to be present with no required attribute)
  let!(:united_arab_emirates) { create(:country, name: "United Arab Emirates", iso_name: "UAE", iso3: "ARE", iso: "AE", states_required: true, zipcode_required: false) }

  # states not required but the country has states listed.
  # (TEST: Expect no required attribute on a select for state, with a blank option for not setting the state),
  let!(:canada) { create(:country, name: "Canada", iso_name: "CAN", iso3: "CAN", iso: "CA", states_required: false, zipcode_required: true, states: create_list(:state, 6)) }

  let(:store) { Spree::Store.default }
  let!(:user_a) { create(:user_with_addresses, email: "a@example.com") }
  let!(:user_b) { create(:user_with_addresses, email: "b@example.com") }
  let!(:user_c) { create(:user_with_addresses, email: "c@example.com") }
  let!(:user_d) { create(:user_with_addresses, email: "d@example.com") }
  let!(:user_e) { create(:user_with_addresses, email: "e@example.com") }
  let!(:user_f) { create(:user_with_addresses, email: "f@example.com") }
  let!(:user_g) { create(:user_with_addresses, email: "g@example.com") }
  let!(:order) { create(:completed_order_with_totals, store: store, user: user_a, number: "R123") }
  let!(:order_2) do
    create(:completed_order_with_totals, store: store, user: user_a, number: "R456").tap do |o|
      li = o.line_items.last
      li.update_column(:price, li.price + 10)
    end
  end
  let!(:order_eur) { create(:completed_order_with_totals, store: store, user: user_a, currency: "EUR") }
  let!(:order_gbp) { create(:completed_order_with_totals, store: store, user: user_a, currency: "GBP") }
  let!(:orders) { Spree::Order.where(id: [order.id, order_2.id, order_eur.id, order_gbp.id]) }

  let!(:store_credit_usd) { create(:store_credit, amount: "100", store: store, user: user_a, currency: "USD") }
  let!(:store_credit_eur) { create(:store_credit, amount: "90", store: store, user: user_a, currency: "EUR") }
  let!(:store_credit_gbp) { create(:store_credit, amount: "80", store: store, user: user_a, currency: "GBP") }

  shared_examples_for "a user page" do
    context "lifetime stats" do
      shared_examples_for "has lifetime stats" do
        it "has lifetime stats" do

        end
      end

      it_behaves_like "has lifetime stats"

      context "when other store order exits" do
        let(:new_store) { create(:store) }
        let!(:new_order) { create(:completed_order_with_totals, store: new_store, number: "K999") }

        it { expect(Spree::Order.count).not_to eq(store.orders.count) }

        it_behaves_like "has lifetime stats"
      end
    end
  end

  shared_examples_for "a sortable attribute" do
    before { click_link sort_link }

    it "can sort asc" do
      within_table(table_id) do
        expect(page).to have_text text_match_1
        expect(page).to have_text text_match_2
        expect(text_match_1).to appear_before text_match_2
      end
    end

    it "can sort desc" do
      within_table(table_id) do
        click_link sort_link

        expect(page).to have_text text_match_1
        expect(page).to have_text text_match_2
        expect(text_match_2).to appear_before text_match_1
      end
    end
  end

  shared_examples_for "a usable address from" do
    it "loads required zipcode field and does not have a sate select or input for United Kingdom" do
      within("#customerAddresses") do
        click_link "Manage"
      end

      within("#shippingAddressActions") do
        click_icon :edit
      end
      wait_for_turbo_frame

      within("#universalModal") do
        select "United Kingdom", from: "address_country_id"

        wait_for_turbo_frame

        expect(page).to have_field("address_zipcode", with: "")
        expect(page).not_to have_select("address_state_id")
      end
    end

    it "loads none required zipcode field and displays a state input field for UAE" do
      within("#customerAddresses") do
        click_link "Manage"
      end

      within("#shippingAddressActions") do
        click_icon :edit
      end
      wait_for_turbo_frame

      within("#universalModal") do
        select "United Arab Emirates", from: "address_country_id"

        wait_for_turbo_frame

        expect(page).to have_field("address_zipcode", with: "")
        expect(page).not_to have_select("address_state_id")
        expect(page).to have_field("address_state_id", with: "")
      end
    end
  end

  before do
    Spree::Config[:company] = true
    create(:country)
    stub_const("Spree::User", create(:user, email: "example@example.com").class)

    visit spree.admin_path
    click_link "Users"
  end

  context "users index" do
    context "email" do
      it_behaves_like "a sortable attribute" do
        let(:text_match_1) { user_a.email }
        let(:text_match_2) { user_b.email }
        let(:table_id) { "listing_users" }
        let(:sort_link) { "users_email_title" }
      end
    end

    it "displays the correct results for a user search" do
      fill_in "q_email_cont", with: user_a.email, visible: false
      click_button "Search", visible: false
      within_table("listing_users") do
        expect(page).to have_text user_a.email
        expect(page).not_to have_text user_b.email
      end
    end

    context "filtering users", js: true do
      it "renders selected filters" do
        click_on "More Filters"
        wait_for_turbo_frame

        within("#universalOffcanvas") do
          click_button "Name and email"
          click_button "Address"

          fill_in "q_email_cont", with: "a@example.com"
          fill_in "q_bill_address_firstname_cont", with: "John"
          fill_in "q_bill_address_lastname_cont", with: "Doe"
          fill_in "q_bill_address_company_cont", with: "Company"
        end

        wait_for_turbo_frame
        click_on "Done"

        within("#index_table") do
          expect(page).to have_content("Email: a@example.com")
          expect(page).not_to have_content("b@example.com")
          expect(page).to have_content("First Name: John")
          expect(page).to have_content("Last Name: Doe")
          expect(page).to have_content("Company: Company")
        end
      end
    end
  end

  context "editing users", js: true do
    before { click_link user_a.email }

    it_behaves_like "a user page"

    it "can edit the user email" do
      within("#customerDetails") do
        click_link "Edit"
      end
      wait_for_turbo_frame

      within("#universalModal") do
        fill_in "user_email", with: "zoo_york@example.com"

        click_button "Save"
      end
      wait_for_turbo_frame

      expect(user_a.reload.email).to eq "zoo_york@example.com"
      expect(page).to have_css(".toast-body", text: "Legacy user has been successfully updated!", visible: :all)
      expect(page).to have_text "zoo_york@example.com"
      expect(page).not_to have_text "a@example.com"
    end

    it "can edit the user password" do
      within("#customerDetails") do
        click_link "Edit"
      end
      wait_for_turbo_frame

      within("#universalModal") do
        fill_in "user_password", with: "welcome"
        fill_in "user_password_confirmation", with: "welcome"

        click_button "Save"
      end
      wait_for_turbo_frame

      expect(page).to have_css(".toast-body", text: "Legacy user has been successfully updated!", visible: :all)
    end

    it "hides roles when none are available" do
      within("#customerDetails") do
        click_link "Edit"
      end
      wait_for_turbo_frame

      within("#universalModal") do
        expect(page).not_to have_text("Roles")
      end
    end

    it "can edit user roles" do
      Spree::Role.create name: "admin"

      within("#customerDetails") do
        click_link "Edit"
      end
      wait_for_turbo_frame

      within("#universalModal") do
        check "user_spree_role_admin"

        click_button "Save"
      end
      wait_for_turbo_frame

      expect(page).to have_css(".toast-body", text: "Legacy user has been successfully updated!", visible: :all)

      within("#customerDetails") do
        click_link "Edit"
      end

      within("#universalModal") do
        expect(page).to have_checked_field("user_spree_role_admin")
      end
    end

    it "can edit user shipping address" do
      within("#customerAddresses") do
        click_link "Manage"
      end

      within("#shippingAddressActions") do
        click_icon :edit
      end
      wait_for_turbo_frame

      within("#universalModal") do
        fill_in "Street", with: "1313 Mockingbird Ln"
        fill_in "City", with: "London"

        # AUSTRALIA
        select "Australia", from: "address_country_id"
        wait_for_turbo_frame
        within("#stateAndZipcode") do
          expect(page).to have_field("address_zipcode", with: "")
          expect(page).to have_xpath("//input[@id='address_zipcode'][@required='required']")
          expect(page).to have_select("address_state_id")
          expect(page).not_to have_field("address_state_name")
        end

        # UAE
        select "United Arab Emirates", from: "address_country_id"
        wait_for_turbo_frame
        within("#stateAndZipcode") do
          expect(page).to have_field("address_zipcode")
          expect(page).not_to have_xpath("//input[@id='address_zipcode'][@required='required']")
          expect(page).not_to have_select("address_state_id")
          expect(page).to have_field("address_state_name")
          expect(page).to have_xpath("//input[@id='address_state_name'][@required='required']")
          expect(page).to have_text("Emirate")
        end

        # CANADA
        select "Canada", from: "address_country_id"
        wait_for_turbo_frame
        within("#stateAndZipcode") do
          expect(page).to have_field("address_zipcode")
          expect(page).to have_xpath("//input[@id='address_zipcode'][@required='required']")
          expect(page).to have_select("address_state_id")
          expect(page).not_to have_xpath("//select[@id='address_state_id'][@required='required']")
          expect(page).not_to have_field("address_state_name")
        end

        # UNITED KINGDOM
        select "United Kingdom", from: "address_country_id"
        wait_for_turbo_frame
        within("#stateAndZipcode") do
          expect(page).to have_field("address_zipcode", with: "")
          expect(page).to have_xpath("//input[@id='address_zipcode'][@required='required']")
          expect(page).not_to have_select("address_state_id")
          expect(page).not_to have_field("address_state_name")

          fill_in "Post Code", with: "LA18 4NE"
        end

        click_button "Save"
      end
      wait_for_turbo_frame

      expect(page).to have_text("1313 Mockingbird Ln")
      expect(page).to have_text("London")
      expect(page).to have_text("LA18 4NE")

      expect(user_a.reload.ship_address.address1).to eq "1313 Mockingbird Ln"
      expect(user_a.ship_address.user_id).to eq user_a.id
    end

    it "can edit user billing address" do
      within("#customerAddresses") do
        click_link "Manage"
      end

      within("#billingAddressActions") do
        click_icon :edit
      end
      wait_for_turbo_frame

      within("#universalModal") do
        fill_in "Street", with: "1212 Mockingbird Ln"
        fill_in "City", with: "London"

        # AUSTRALIA
        select "Australia", from: "address_country_id"
        wait_for_turbo_frame
        within("#stateAndZipcode") do
          expect(page).to have_field("address_zipcode", with: "")
          expect(page).to have_xpath("//input[@id='address_zipcode'][@required='required']")
          expect(page).to have_select("address_state_id")
          expect(page).not_to have_field("address_state_name")
        end

        # UAE
        select "United Arab Emirates", from: "address_country_id"
        wait_for_turbo_frame
        within("#stateAndZipcode") do
          expect(page).to have_field("address_zipcode")
          expect(page).not_to have_xpath("//input[@id='address_zipcode'][@required='required']")
          expect(page).not_to have_select("address_state_id")
          expect(page).to have_field("address_state_name")
          expect(page).to have_xpath("//input[@id='address_state_name'][@required='required']")
          expect(page).to have_text("Emirate")
        end

        # CANADA
        select "Canada", from: "address_country_id"
        wait_for_turbo_frame
        within("#stateAndZipcode") do
          expect(page).to have_field("address_zipcode")
          expect(page).to have_xpath("//input[@id='address_zipcode'][@required='required']")
          expect(page).to have_select("address_state_id")
          expect(page).not_to have_xpath("//select[@id='address_state_id'][@required='required']")
          expect(page).not_to have_field("address_state_name")
        end

        # UNITED KINGDOM
        select "United Kingdom", from: "address_country_id"
        wait_for_turbo_frame
        within("#stateAndZipcode") do
          expect(page).to have_field("address_zipcode", with: "")
          expect(page).to have_xpath("//input[@id='address_zipcode'][@required='required']")
          expect(page).not_to have_select("address_state_id")
          expect(page).not_to have_field("address_state_name")

          fill_in "Post Code", with: "LA18 6NE"
        end

        click_button "Save"
      end
      wait_for_turbo_frame

      expect(page).to have_text("1212 Mockingbird Ln")
      expect(page).to have_text("London")
      expect(page).to have_text("LA18 6NE")

      expect(user_a.reload.bill_address.address1).to eq "1212 Mockingbird Ln"
      expect(user_a.bill_address.user_id).to eq user_a.id
    end

    it "can set shipping address to be the same as billing address" do
      within("#customerAddresses") do
        click_link "Manage"
      end

      within("#billingAddressActions") do
        click_button "use_billing_for_shipping"
      end
      wait_for_turbo_frame

      expect(user_a.reload.ship_address == user_a.reload.bill_address).to eq true
    end
  end

  context "order history with sorting" do
    before do
      orders
      visit spree.orders_admin_user_path(user_a)
    end

    context "completed_at" do
      it_behaves_like "a sortable attribute" do
        let(:text_match_1) { order_time(order.completed_at) }
        let(:text_match_2) { order_time(order_2.completed_at) }
        let(:table_id) { "listing_orders" }
        let(:sort_link) { "orders_completed_at_title" }
      end
    end

    [:number, :state, :total].each do |attr|
      context attr do
        it_behaves_like "a sortable attribute" do
          let(:text_match_1) { order.send(attr).to_s }
          let(:text_match_2) { order_2.send(attr).to_s }
          let(:table_id) { "listing_orders" }
          let(:sort_link) { "orders_#{attr}_title" }
        end
      end
    end
  end
end
