require 'spec_helper'

describe BranchesController do
  describe 'GET #show' do
    let(:params) do
      {
        id: 1,
        format: 'json'
      }
    end

    before do
      VCR.use_cassette "branches/#{params[:id]}" do
        get :show, params
      end
    end

    it { expect(response).to be_success }
  end
end
