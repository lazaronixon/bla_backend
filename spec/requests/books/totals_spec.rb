require 'rails_helper'

RSpec.describe "/books/total", type: :request do
  let(:auth_headers) { { "Authorization" => "Bearer #{users(:librarian).signed_id}" } }

  describe "GET /books/total" do
    it "returns total books and total borrowed" do
      get books_total_url, headers: auth_headers, as: :json
      expect(response).to be_successful
      expect(response.parsed_body["total_books"]).to eq(Book.count)
      expect(response.parsed_body["total_borrowed"]).to eq(Borrowing.active.count)
    end
  end
end
