class ConvertController < ActionController::Base
  respond_to :html, :xml, :json

  def index
    respond_with(@switches) do |format|
      format.html
      format.json { render :none => true }
    end
  end
end