class EndUserBaseController < ApplicationController
  before_filter :authenticate_user!
end
