require 'rails_helper'

RSpec.describe "/books/:book_id/borrowings", type: :request do
  let(:auth_headers) { { "Authorization" => "Bearer #{users(:member).signed_id}" } }

  describe "GET /index" do
    it "renders a successful response" do
      get book_borrowings_url(books(:dune)), headers: auth_headers, as: :json
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      get book_borrowing_url(books(:dune), borrowings(:active_borrowing)), headers: auth_headers, as: :json
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    it "creates a new borrowing" do
      member_two_headers = { "Authorization" => "Bearer #{users(:member_three).signed_id}" }
      expect {
        post book_borrowings_url(books(:dune)), headers: member_two_headers, as: :json
      }.to change(Borrowing, :count).by(1)

      expect(response).to have_http_status(:created)
    end

    it "returns forbidden for a librarian" do
      librarian_headers = { "Authorization" => "Bearer #{users(:librarian).signed_id}" }
      post book_borrowings_url(books(:dune)), headers: librarian_headers, as: :json
      expect(response).to have_http_status(:forbidden)
    end

    it "returns unprocessable when book is unavailable" do
      expect {
        post book_borrowings_url(books(:pride_and_prejudice)), headers: auth_headers, as: :json
      }.not_to change(Borrowing, :count)

      expect(response).to have_http_status(:unprocessable_content)
      expect(response.parsed_body["error"]).to include("is not available")
    end

    it "returns unprocessable when book is already borrowed by the user" do
      expect {
        post book_borrowings_url(books(:dune)), headers: auth_headers, as: :json
      }.not_to change(Borrowing, :count)

      expect(response).to have_http_status(:unprocessable_content)
      expect(response.parsed_body["error"]).to include("is already borrowed")
    end
  end

  describe "DELETE /destroy" do
    let(:librarian_headers) { { "Authorization" => "Bearer #{users(:librarian).signed_id}" } }

    it "destroys the borrowing" do
      expect {
        delete book_borrowing_url(books(:dune), borrowings(:active_borrowing)), headers: librarian_headers, as: :json
      }.to change(Borrowing, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end

    it "returns forbidden for a member" do
      delete book_borrowing_url(books(:dune), borrowings(:active_borrowing)), headers: auth_headers, as: :json
      expect(response).to have_http_status(:forbidden)
    end
  end

  describe "PATCH /update" do
    let(:librarian_headers) { { "Authorization" => "Bearer #{users(:librarian).signed_id}" } }

    it "sets returned_at on the borrowing" do
      patch book_borrowing_url(books(:dune), borrowings(:active_borrowing)), headers: librarian_headers, as: :json
      expect(response).to be_successful
      expect(borrowings(:active_borrowing).reload.returned_at).not_to be_nil
    end

    it "returns forbidden for a member" do
      patch book_borrowing_url(books(:dune), borrowings(:active_borrowing)), headers: auth_headers, as: :json
      expect(response).to have_http_status(:forbidden)
    end
  end
end
