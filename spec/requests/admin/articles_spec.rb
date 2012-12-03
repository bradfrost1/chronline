require 'spec_helper'

describe "Admin::Articles" do
  subject { page }

  describe "creation" do
    before do
      default_url_options[:host] = "lvh.me"
      default_url_options[:port] = "3000"
      visit new_admin_article_url(:subdomain => :admin)
    end

    let(:submit) { "Create Article" }

    describe "with invalid information" do
      before { fill_in "Subtitle", with: "Oak arrives just in time" }

      it "should not create an article" do
        expect { click_button :submit }.not_to change(Article, :count)
      end

      it "should display errors" do
        click_button :submit
        find_field("Title").native.next_sibling
          .text.should include("can't be blank")
        find_field("Title").native.parent.parent
          .get_attribute(:class).should include('error')
        find_field("Body").native.next_sibling
          .text.should include("can't be blank")
        find_field("Body").native.parent.parent
          .get_attribute(:class).should include('error')
      end
    end

    describe "with valid information" do
      before do
        fill_in "Title", with: "Ash defeats Gary in Indigo Plateau"
        fill_in "Subtitle", with: "Oak arrives just in time"
        fill_in "Teaser", with: "Ash becomes new Pokemon Champion."
        fill_in "Body", with: "**Pikachu** wrecks everyone. The End."
      end

      it "should create an Article" do
        expect { click_button :submit }.to change(Article, :count).by(1)
      end
    end
  end
end
