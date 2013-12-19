require 'json'
require 'date'
require 'rest'

class ConvertController < ApplicationController
  respond_to :html, :xml, :json, :yaml

  def current()
     @response = {
     'in_time' => '',
     'in_timezone' => '',
     'out_time' => '',
     'out_timezone' => '',
     'current_time' => true
    }

    date = DateTime.now
    @response['out_time'] = date.to_formatted_s(:time)
    @response['out_date'] = date.strftime("%d/%m")
    @response['out_timezone'] = "UTC+0"
  end

  def getTimezone()
    url = 'http://api.ipinfodb.com/v3/ip-city/?key=3d3ffa73b3ae5e0307afc03a09f818af9a1ad47bee870dea658e86df13e844de&format=json&ip=' + (request.remote_ip || '0.0.0.0')
    rest = Rest::Client.new
    response = rest.get url
    result = JSON.parse(response.body)
    return result['timeZone']
  end

  def index()
    if (params.has_key?('nojs'))
      params[:format] = 'json'
      @response = convert()
    else
      render template: 'convert/loading'
    end
  end

  def convert()
    @response = {
     'in_time' => '',
     'in_timezone' => '',
     'out_time' => '',
     'out_timezone' => '',
     'current_time' => false
    }

    params[:format] = ''

    if (params[:requirements])
      params[:format] = params[:requirements][:ext] || ""
    end

    params[:time] = params[:time] || DateTime.now.strftime("%H:%M")
    timezone = request.headers['x-timezone'] || params[:timezone] || getTimezone()

    #parse the params time
    # => 1100
    # => 11
    # => 1
    if (timezone != nil)
      # replace common timezones with proper timezone
      # => CT => CST
      # => PT => PST
      timezone = timezone.gsub(/ct/i, "CST")
      params[:time] = params[:time].gsub(/ct/i, "CST")
      timezone = timezone.gsub(/pt/i, "PST")
      params[:time] = params[:time].gsub(/pt/i, "PST")

      # format all non 0-9, a-z, :, -, + characters
      params[:time] = params[:time].gsub(/([^0-9A-Za-z:-\\+\s-]+)/, "")

      if (!params[:time].include?(":"))
        time = params[:time].gsub(/([a-zA-Z\+\-\s]([0-9]+)?)+/, "")

        if (time.length < 1)
          #try_render({"error" => "invalid date"})
          #return
          time = DateTime.now.strftime("%H%M")
          params[:time] = "#{time.to_s} #{params[:time]}"
          @response['current_time'] = true
        end

        newtime = time.clone

        if (newtime.length == 1)
          newtime = "0" + newtime + "00"
        elsif (newtime.length == 2)
          newtime += "00"
        end

        if (newtime.length > 2)
          newtime = newtime.insert(newtime.length - 2, ":")
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
      z = params[:time].clone
      z = z.gsub(/(pm|am)/i, "")
      matches = z.match(/([a-zA-Z\+\-\s]([0-9]+)?)+/)
      @response['in_timezone'] = matches == nil ? "" : matches[0].upcase
      @response['in_timezone'] = @response['in_timezone'].strip

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
      
      begin
        in_time = DateTime.parse(params[:time])

        if (@response['current_time'])
        	mod = @response['in_timezone'].gsub(/[^0-9\+\-]/, "").to_i
        	final_time = in_time.to_i + (mod * 60 * 60) * 2
        else
        	timezone_diff = timezone.to_i * 60 * 60
        	final_time = in_time.to_i + timezone_diff
        end

        date = Time.at(final_time).utc()
        @response['in_time'] = in_time.to_formatted_s(:time)
        @response['out_time'] = date.to_formatted_s(:time)
        @response['out_date'] = date.strftime("%d/%m")
        @response['out_timezone'] = "UTC" + timezone
        @response['timestamp'] = date.to_i
      rescue Exception => ex
        @response = {"error" => {"message" => ex.message}, "code" => 1}
      end
    else
      @response = {"error" => {"message" => "No timezone supplied. Supply a header with the key \"x-timezone\" or a request parameter with the name \"timezone\""}}
    end

    try_render(@response)
    return @response
  end

  def try_render(response)
    if (params[:format] == 'json')
      render :layout => false, :json => response.to_json
    elsif (params[:format] == 'xml')
      if (response['error'])
        render :layout => false, :xml => response.to_xml(:root => 'error')
        return
      end

      render :layout => false, :xml => response.to_xml(:root => 'time')
    elsif (params[:format] == 'yaml')
      render :layout => false, :text => response.to_yaml
    end
  end
end