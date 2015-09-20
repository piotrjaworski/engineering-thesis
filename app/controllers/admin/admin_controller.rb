class Admin::AdminController < ApplicationController
  before_action :check_admin
  layout :admin_assets

  private

    def admin_assets
      "admin"
    end

end
