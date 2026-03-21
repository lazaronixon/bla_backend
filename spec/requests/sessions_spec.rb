require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  describe "POST /sign_in" do
    context "with valid credentials" do
      it "returns 201 and sets X-Session-Token header" do
        post "/sign_in", params: { email_address: users(:member).email_address, password: "password123" }, as: :json

        expect(response).to have_http_status(:created)
        expect(response.headers["X-Session-Token"]).to be_present
        expect(response.headers["X-Session-Expires-In"]).to eq(SessionsController::SESSION_DURATION)
      end
    end

    context "with invalid credentials" do
      it "returns 401 with an error message" do
        post "/sign_in", params: { email_address: users(:member).email_address, password: "wrongpassword" }, as: :json

        expect(response).to have_http_status(:unauthorized)
        expect(response.parsed_body["error"]).to be_present
      end
    end
  end

  describe "DELETE /sign_out" do
    it "returns 200" do
      delete "/sign_out", as: :json

      expect(response).to have_http_status(:ok)
    end
  end
end
