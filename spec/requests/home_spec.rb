require 'rails_helper'

RSpec.describe "Homes", type: :request do
  describe "/" do
    it "ルートパスからhome/indexのviewに遷移している" do
      get root_path
      expect(response).to have_http_status(:success)
    end
  end
end
