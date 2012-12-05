require 'json'

class ConvertController < ApplicationController
  respond_to :html, :xml, :json

  def index
    @response = {
     'out_time' => '4pm'
    }

    if (request.fullpath.include?("nojs"))
      @response['out_time'] = "DICK, STOP BLOCKING JS"
    end

    respond_with(@switches) do |format|
      format.html
      format.json { render :json => @response.to_json }
      format.xml { render :xml => @response.to_xml(:root => 'time') }
    end
  end
end