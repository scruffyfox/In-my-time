require 'json'
require 'date'

class ConvertController < ApplicationController
  respond_to :html, :xml, :json

  def index
    @response = {
     'out_time' => '4pm'
    }

    timezone = request.headers['x-timezone'] || "0"
    #timezone = "-300" #EST -300 minutes
    #timezone = "GMT" #GMT -300 minutes

    #detect what timezone they sent
    #whole numbers mean minutes offset from UTC
    #accepted other formats:
    # => (GMT/UTC)+/-0-14
    # => 

    if (timezone.match(/[^0-9+-]/))
      zone = DateTime.parse("1/1/1970 12am " + timezone).to_i
      timezone = -(zone / 60)
    end

    timezone = timezone.to_i
    if (timezone != 0)
      timezone = timezone.to_i / 60
    end

    timezone = (timezone < 0 ? "" : "+") + timezone.to_s
    timezone_diff = timezone.to_i * 60 * 60

    test = DateTime.parse(params[:time])
    final_time = test.to_i + timezone_diff

    date = Time.at(final_time).utc()
    puts date
    @response['out_time'] = date.to_formatted_s(:time)
    @response['out_date'] = date.strftime("%d/%m")

    if (request.fullpath.include?("nojs"))
      #figgure out timezone from IP
      @response['out_time'] = "DICK, STOP BLOCKING JS"
    else

    end

    #puts timezone

    respond_with(@switches) do |format|
      format.html
      format.json { render :json => @response.to_json }
      format.xml { render :xml => @response.to_xml(:root => 'time') }
    end
  end
end