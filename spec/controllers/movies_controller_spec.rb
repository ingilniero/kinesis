require 'spec_helper'

describe MoviesController do
  describe 'POST #show' do
    let(:params) do
      {
        id: 19210,
        format: 'json'
      }
    end

    before do
      VCR.use_cassette "movies/#{params[:id]}" do
        get :show, params
      end
    end

    it { expect(response).to be_success }
  end

end
