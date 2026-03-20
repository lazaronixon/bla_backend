require 'rails_helper'

RSpec.describe "/books/due_today", type: :request do
  let(:librarian_headers) { { "Authorization" => "Bearer #{users(:librarian).signed_id}" } }
  let(:member_headers)    { { "Authorization" => "Bearer #{users(:member).signed_id}" } }

  describe "GET /books/due_today" do
    it "returns borrowings due today" do
      get books_due_today_url, headers: librarian_headers, as: :json
      expect(response).to be_successful
      expect(response.parsed_body.map { |b| b["id"] }).to include(borrowings(:due_today_borrowing).id)
    end

    it "excludes borrowings not due today" do
      get books_due_today_url, headers: librarian_headers, as: :json
      expect(response.parsed_body.map { |b| b["id"] }).not_to include(borrowings(:active_borrowing).id)
    end

    it "returns forbidden for a member" do
      get books_due_today_url, headers: member_headers, as: :json
      expect(response).to have_http_status(:forbidden)
    end
  end
end
