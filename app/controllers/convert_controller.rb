require 'json'
require 'date'

class ConvertController < ApplicationController
  respond_to :html, :xml, :json

  def index
    @response = {
     'out_time' => '',
     'out_date' => '',
     'out_timezone' => ''
    }

    #parse the params time
    # => 1100
    # => 11
    # => 1
    params[:time] = params[:time] || DateTime.now.strftime("%H:%M")
    timezone = request.headers['x-timezone'] || return

    if (params[:time].include?(":"))
      if (params[:time].match(/(am|pm)/))
        # => 15:00pm | 15:00am
      else
        # => 15:00
      end
    else
      if (params[:time].match(/(am|pm)/))
        # => 1500am | 1500pm
      else
        # => 1500
        time = params[:time].gsub(/[^0-9]/, "")
        newtime = time.clone

        newtime = newtime.insert(newtime.length - 2, ":")
        puts newtime

        if (newtime.length == 2)
          newtime += "00"
        end

        if (newtime.length < 4)
          tmptime = []
          newtime.split(":").each do |part|
            tmptime.push(part.ljust(2, '0'))
          end

          newtime = tmptime.reverse.join(":")
        end

        puts newtime

        params[:time] = params[:time].gsub(time, newtime)
      end
    end

    if (params[:time].match(/(am|pm)(\s{0}?)/))
      # => 15:00pm | 15:00am
      params[:time] = params[:time].sub(/(am|pm)/){$1 + " "}
    end

    puts params[:time]

    timezone = timezone.gsub(/\s/, "")
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
    @response['out_time'] = date.to_formatted_s(:time)
    @response['out_date'] = date.strftime("%d/%m")
    @response['out_timezone'] = "UTC" + timezone

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