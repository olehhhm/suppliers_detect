require "rails_helper"

RSpec.describe "SupplierDeliveries", type: :request do
  describe "POST /supplier_delivery" do
    before { post "/supplier_delivery", params: params }
    context "when params is valid" do
      
      context "when product exist" do
        let!(:params) { {region: "us", basket: { items: [ {product: "black_mug", count: 1} ] } } }
        it "returns status code 200" do
          expect(response).to have_http_status(200)
        end
        it "respond with json" do
          expect(response.header["Content-Type"]).to include("application/json")
        end
        it "include result" do
          expect(JSON.parse(response.body)).to include("result")
        end
      end

      
      context "when product doesn't exist" do
        let!(:params) { {region: "us", basket: { items: [ {product: "black_mug1", count: 1} ] } } }
        it "returns status code 200" do
          expect(response).to have_http_status(200)
        end
        it "respond with json" do
          expect(response.header["Content-Type"]).to include("application/json")
        end
        it "include errors" do
          expect(JSON.parse(response.body)).to include("errors")
        end
      end

    end

    context "when params is invalid" do
      context "when params doesn't have basket" do
        let!(:params) { { region: "us" }  }
        it "returns status code 200" do
          expect(response).to have_http_status(400)
        end
        it "respond with json" do
          expect(response.header["Content-Type"]).to include("application/json")
        end
        it "include errors" do
          parsed = JSON.parse(response.body)
          expect(parsed).to include("message")
        end
      end

      context "when params doesn't have region" do
        let!(:params) { { basket: { items: [ {product: "black_mug", count: 1} ] } } }
        it "returns status code 200" do
          expect(response).to have_http_status(400)
        end
        it "respond with json" do
          expect(response.header["Content-Type"]).to include("application/json")
        end
        it "include errors" do
          parsed = JSON.parse(response.body)
          expect(parsed).to include("message")
        end
      end

      context "when one of items doesn't have product" do
        let!(:params) { {region: "us", basket: { items: [ {count: 1} ] } } }
        it "returns status code 200" do
          expect(response).to have_http_status(400)
        end
        it "respond with json" do
          expect(response.header["Content-Type"]).to include("application/json")
        end
        it "include errors" do
          parsed = JSON.parse(response.body)
          expect(parsed).to include("message")
        end
      end

      context "when one of items doesn't have count" do
        let!(:params) { {region: "us", basket: { items: [ {product: "black_mug"}] } } }
        it "returns status code 200" do
          expect(response).to have_http_status(400)
        end
        it "respond with json" do
          expect(response.header["Content-Type"]).to include("application/json")
        end
        it "include errors" do
          parsed = JSON.parse(response.body)
          expect(parsed).to include("message")
        end
      end
    end
  end
end
