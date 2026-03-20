class Books::BorrowedsController < ApplicationController
  before_action :ensure_member

  def show
    @borrowings = Current.user.borrowings.reverse_chronologically
  end
end
