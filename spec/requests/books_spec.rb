require 'rails_helper'

RSpec.describe "/books", type: :request do
  let(:auth_headers)      { { "Authorization" => "Bearer #{users(:member).signed_id}" } }
  let(:librarian_headers) { { "Authorization" => "Bearer #{users(:librarian).signed_id}" } }

  describe "GET /index" do
    it "renders a successful response" do
      get books_url, headers: auth_headers, as: :json
      expect(response).to be_successful
    end

    it "filters by query" do
      get books_url(q: "frank herbert"), headers: auth_headers, as: :json
      expect(response.parsed_body.map { |book| book["title"] }).to contain_exactly("Dune")
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      get book_url(books(:dune)), headers: auth_headers, as: :json
      expect(response).to be_successful
    end

    it "includes available count in the response" do
      get book_url(books(:dune)), headers: auth_headers, as: :json
      expect(response.parsed_body["available"]).to eq(books(:dune).available)
    end
  end

  describe "POST /create" do
    it "creates a new Book" do
      expect {
        post books_url, params: { book: { title: "Foundation", author: "Isaac Asimov", genre: "Sci-Fi", isbn: "978-0553293357", copies: 2 } }, headers: librarian_headers, as: :json
      }.to change(Book, :count).by(1)

      expect(response).to have_http_status(:created)
    end

    it "returns forbidden for a member" do
      post books_url, params: { book: { title: "Foundation" } }, headers: auth_headers, as: :json
      expect(response).to have_http_status(:forbidden)
    end
  end

  describe "PATCH /update" do
    it "updates the requested book" do
      patch book_url(books(:dune)), params: { book: { title: "Dune Messiah" } }, headers: librarian_headers, as: :json
      expect(response).to have_http_status(:ok)
    end

    it "returns forbidden for a member" do
      patch book_url(books(:dune)), params: { book: { title: "Dune Messiah" } }, headers: auth_headers, as: :json
      expect(response).to have_http_status(:forbidden)
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested book" do
      expect {
        delete book_url(books(:dune)), headers: librarian_headers, as: :json
      }.to change(Book, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end

    it "returns forbidden for a member" do
      delete book_url(books(:dune)), headers: auth_headers, as: :json
      expect(response).to have_http_status(:forbidden)
    end
  end
end
