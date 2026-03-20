class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods

  before_action :authenticate

  private
    def authenticate
      if user = authenticate_with_http_token { |token, _| User.find_signed(token) }
        Current.user = user
      else
        request_http_token_authentication
      end
    end

    def ensure_librarian
      head :forbidden unless Current.user.librarian?
    end

    def ensure_member
      head :forbidden unless Current.user.member?
    end
end
