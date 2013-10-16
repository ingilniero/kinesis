class BranchesController < ApplicationController
  respond_to :json
  def show
    @branch  = Branch.new(params)
    respond_with @branch.get_json
  end
end
