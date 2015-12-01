require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  let(:topic) { create(:topic) }

  describe "GET #index" do
    it "returns http success" do
      get :index, page: 2
      expect(response).to have_http_status(:success)
    end
  end
end
