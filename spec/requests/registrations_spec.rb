require 'rails_helper'

RSpec.describe "Registrations", type: :request do
  describe "POST /sign_up" do
    context "with valid parameters" do
      it "creates a new user and returns 201" do
        expect {
          post "/sign_up", params: { email_address: "newuser@example.com", password: "secret123", password_confirmation: "secret123" }, as: :json
        }.to change(User, :count).by(1)

        expect(response).to have_http_status(:created)
      end
    end

    context "with invalid parameters" do
      it "does not create a user and returns 422" do
        expect {
          post "/sign_up", params: { email_address: users(:existing_member).email_address, password: "secret123", password_confirmation: "secret123" }, as: :json
        }.not_to change(User, :count)

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
