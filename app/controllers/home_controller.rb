class HomeController < ApplicationController
  before_action :authenticate_account!, only: :show
  def index
  end

  def show
  end
end
