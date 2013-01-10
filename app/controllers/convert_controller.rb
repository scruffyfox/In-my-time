require 'json'
require 'date'

class ConvertController < ApplicationController
  respond_to :html, :xml, :json, :yaml

  def current
     @response = {
     'in_time' => '',
     'in_timezone' => '',
     'out_time' => '',
     #'out_date' => '',
     'out_timezone' => ''
    }

    date = DateTime.now
    @response['out_time'] = date.to_formatted_s(:time)
    @response['out_date'] = date.strftime("%d/%m")
    @response['out_timezone'] = "UTC+0"
  end

  def index
    @response = {
     'in_time' => '',
     'in_timezone' => '',
     'out_time' => '',
     #'out_date' => '',
     'out_timezone' => ''
    }

    params[:time] = params[:time] || DateTime.now.strftime("%H:%M")
    timezone = request.headers['x-timezone'] || params[:timezone] || "UTC"

    if (!(params[:format] || "").match(/(json|xml|html|yaml)/))
      params[:time] += "." + (params[:format] || "").clone
      params[:format] = "html"
    end

    #parse the params time
    # => 1100
    # => 11
    # => 1

    if (timezone != nil)
      # replace common timezones with proper timezone
      # => CT => CST
      timezone = timezone.gsub(/ct/i, "CST")
      params[:time] = params[:time].gsub(/ct/i, "CST")

      # format all non 0-9, a-z, :, -, + characters
      params[:time] = params[:time].gsub(/([^0-9A-Za-z:-\\+\s-]+)/, "")

      if (params[:time].include?(":"))
        if (params[:time].match(/(am|pm)/))
          # => 15:00pm | 15:00am
        else
          # => 15:00
        end
      else
        time = params[:time].gsub(/[^0-9]/, "")

        if (time.length < 1)
          try_render({"error" => "invalid date"})
          return
        end

        newtime = time.clone
        newtime = newtime.insert(newtime.length - 2, ":")

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

        params[:time] = params[:time].gsub(time, newtime)
      end

      if (params[:time].match(/(am|pm)(\s{0}?)/))
        # => 15:00pm | 15:00am
        params[:time] = params[:time].sub(/(am|pm)/){$1 + " "}
      end

      timezone = timezone.gsub(/\s/, "")
      @response['in_timezone'] = params[:time].clone.gsub(/([0-9:.\\+\s-]+)(am|pm)/i, "").strip.upcase

      #timezone = "-300" #EST -300 minutes
      #timezone = "GMT" #GMT -300 minutes

      #detect what timezone they sent
      #whole numbers mean minutes offset from UTC
      #accepted other formats:
      # => (GMT/UTC)+/-0-14

      if (timezone.match(/[^0-9\+-]/))
        if (!timezone.match(/(-|\+)/))
          tmp_zone = timezone.clone
          tmp_zone = tmp_zone.gsub(/[^0-9-]/, "")
          original_zone_time = tmp_zone.clone

          if (tmp_zone.to_i > 0)
            tmp_zone = "+" + tmp_zone
            timezone = timezone.gsub(original_zone_time, tmp_zone)
          end
        end

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
      @response['in_time'] = test.to_formatted_s(:time)
      @response['out_time'] = date.to_formatted_s(:time)
      @response['out_date'] = date.strftime("%d/%m")
      @response['out_timezone'] = "UTC" + timezone

      if (request.fullpath.include?("nojs"))
        #figgure out timezone from IP
        @response['out_time'] = "TBI"
      else

      end
    else
      @response = {"error" => {"message" => "No timezone supplied. Supply a header with the key \"x-timezone\" or a request parameter with the name \"timezone\""}}
    end

    try_render(@response)
  end

  def try_render(response)
    if (params[:format] == 'json')
      render :json => response.to_json
    elsif (params[:format] == 'xml')
      if (response['error'])
        render :xml => response.to_xml(:root => 'error')
        return
      end

      render :xml => response.to_xml(:root => 'time')
    elsif (params[:format] == 'yaml')
      puts "test"
      render :text => response.to_yaml
    end
  end
end