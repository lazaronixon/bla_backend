require 'rails_helper'

RSpec.describe "GET /my/user", type: :request do
  let(:auth_headers) { { "Authorization" => "Bearer #{users(:member).signed_id}" } }

  context "when authenticated" do
    it "returns 200" do
      get my_user_url, headers: auth_headers, as: :json
      expect(response).to have_http_status(:ok)
    end

    it "returns the current user's profile" do
      get my_user_url, headers: auth_headers, as: :json

      body = response.parsed_body
      expect(body["id"]).to eq(users(:member).id)
      expect(body["email_address"]).to eq(users(:member).email_address)
      expect(body["role"]).to eq("member")
      expect(body["borrowed_books_count"]).to eq(users(:member).borrowed_books_count)
      expect(body["overdue_books_count"]).to eq(users(:member).overdue_books_count)
    end
  end

  context "when unauthenticated" do
    it "returns 401" do
      get my_user_url, as: :json
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
