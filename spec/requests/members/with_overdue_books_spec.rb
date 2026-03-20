require 'rails_helper'

RSpec.describe "/members/with_overdue_books", type: :request do
  let(:librarian_headers) { { "Authorization" => "Bearer #{users(:librarian).signed_id}" } }
  let(:member_headers)    { { "Authorization" => "Bearer #{users(:existing_member).signed_id}" } }

  describe "GET /members/with_overdue_books" do
    it "returns members with overdue borrowings" do
      get members_with_overdue_books_url, headers: librarian_headers, as: :json
      expect(response).to be_successful
      expect(response.parsed_body.map { |u| u["id"] }).to include(users(:another_member).id)
    end

    it "excludes members without overdue borrowings" do
      get members_with_overdue_books_url, headers: librarian_headers, as: :json
      expect(response.parsed_body.map { |u| u["id"] }).not_to include(users(:existing_member).id)
    end

    it "returns results ordered alphabetically by email" do
      get members_with_overdue_books_url, headers: librarian_headers, as: :json
      emails = response.parsed_body.map { |u| u["email_address"] }
      expect(emails).to eq(emails.sort)
    end

    it "returns forbidden for a member" do
      get members_with_overdue_books_url, headers: member_headers, as: :json
      expect(response).to have_http_status(:forbidden)
    end
  end
end
