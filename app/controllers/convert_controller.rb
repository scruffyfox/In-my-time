require 'json'
require 'date'
require 'rest'
include ActiveSupport

$TIMEZONES = {
    "ACDT" => ["Australian Central Daylight Savings Time", "UTC+10:30"],
    "ACST" => ["Australian Central Standard Time", "UTC+9:30"],
    "ACT" => ["ASEAN Common Time", "UTC+8"],
    "ADT" => ["Atlantic Daylight Time", "UTC-3"],
    "AEDT" => ["Australian Eastern Daylight Savings Time", "UTC+11"],
    "AEST" => ["Australian Eastern Standard Time", "UTC+10"],
    "AFT" => ["Afghanistan Time", "UTC+4:30"],
    "AKDT" => ["Alaska Daylight Time", "UTC-8"],
    "AKST" => ["Alaska Standard Time", "UTC-9"],
    "AMST" => ["Armenia Summer Time", "UTC+5"],
    "AMT" => ["Armenia Time", "UTC+4"],
    "ART" => ["Argentina Time", "UTC-3"],
    "AST" => ["Atlantic Standard Time", "UTC-4"],
    "AWDT" => ["Australian Western Daylight Time", "UTC+9"],
    "AWST" => ["Australian Western Standard Time", "UTC+8"],
    "AZOST" => ["Azores Standard Time", "UTC-1"],
    "AZT" => ["Azerbaijan Time", "UTC+4"],
    "BDT" => ["Brunei Time", "UTC+8"],
    "BIOT" => ["British Indian Ocean Time", "UTC+6"],
    "BIT" => ["Baker Island Time", "UTC-12"],
    "BOT" => ["Bolivia Time", "UTC-4"],
    "BRT" => ["Brasilia Time", "UTC-3"],
    "BST" => ["Bangladesh Standard Time", "UTC+6"],
    "BST" => ["British Summer Time", "UTC+1"],
    "BTT" => ["Bhutan Time", "UTC+6"],
    "CAT" => ["Central Africa Time", "UTC+2"],
    "CCT" => ["Cocos Islands Time", "UTC+6:30"],
    "CDT" => ["Central Daylight Time", "UTC-5"],
    "CEDT" => ["Central European Daylight Time", "UTC+2"],
    "CEST" => ["Central European Summer Time (Cf. HAEC)", "UTC+2"],
    "CET" => ["Central European Time", "UTC+1"],
    "CHADT" => ["Chatham Daylight Time", "UTC+13:45"],
    "CHAST" => ["Chatham Standard Time", "UTC+12:45"],
    "CHOT" => ["Choibalsan", "UTC+8"],
    "ChST" => ["Chamorro Standard Time", "UTC+10"],
    "CHUT" => ["Chuuk Time", "UTC+10"],
    "CIST" => ["Clipperton Island Standard Time", "UTC-8"],
    "CIT" => ["Central Indonesia Time", "UTC+8"],
    "CKT" => ["Cook Island Time", "UTC-10"],
    "CLST" => ["Chile Summer Time", "UTC-3"],
    "CLT" => ["Chile Standard Time", "UTC-4"],
    "COST" => ["Colombia Summer Time", "UTC-4"],
    "COT" => ["Colombia Time", "UTC-5"],
    "CST" => ["Central Standard Time (North America)", "UTC-6"],
    "CT" => ["Central Standard Time (North America)", "UTC-6"],
    "CVT" => ["Cape Verde Time", "UTC-1"],
    "CXT" => ["Christmas Island Time", "UTC+7"],
    "DAVT" => ["Davis Time", "UTC+7"],
    "DDUT" => ["Dumont d'Urville Time", "UTC+10"],
    "DFT" => ["AIX specific equivalent of Central European Time", "UTC+1"],
    "EASST" => ["Easter Island Standard Summer Time", "UTC-5"],
    "EAST" => ["Easter Island Standard Time", "UTC-6"],
    "EAT" => ["East Africa Time", "UTC+3"],
    "ECT" => ["Ecuador Time", "UTC-5"],
    "EDT" => ["Eastern Daylight Time (North America)", "UTC-4"],
    "EEDT" => ["Eastern European Daylight Time", "UTC+3"],
    "EEST" => ["Eastern European Summer Time", "UTC+3"],
    "EET" => ["Eastern European Time", "UTC+2"],
    "EGST" => ["Eastern Greenland Summer Time", "UTC"],
    "EGT" => ["Eastern Greenland Time", "UTC-1"],
    "EIT" => ["Eastern Indonesian Time", "UTC+9"],
    "EST" => ["Eastern Standard Time (North America)", "UTC-5"],
    "FET" => ["Further-eastern European Time", "UTC+3"],
    "FJT" => ["Fiji Time", "UTC+12"],
    "FKST" => ["Falkland Islands Standard Time", "UTC-3"],
    "FKT" => ["Falkland Islands Time", "UTC-4"],
    "FNT" => ["Fernando de Noronha Time", "UTC-2"],
    "GALT" => ["Galapagos Time", "UTC-6"],
    "GAMT" => ["Gambier Islands", "UTC-9"],
    "GET" => ["Georgia Standard Time", "UTC+4"],
    "GFT" => ["French Guiana Time", "UTC-3"],
    "GILT" => ["Gilbert Island Time", "UTC+12"],
    "GIT" => ["Gambier Island Time", "UTC-9"],
    "GMT" => ["Greenwich Mean Time", "UTC"],
    "GST" => ["Gulf Standard Time", "UTC+4"],
    "GYT" => ["Guyana Time", "UTC-4"],
    "HADT" => ["Hawaii-Aleutian Daylight Time", "UTC-9"],
    "HAEC" => ["Heure Avance dEurope Centrale francised name for CEST", "UTC+2"],
    "HAST" => ["Hawaii-Aleutian Standard Time", "UTC-10"],
    "HKT" => ["Hong Kong Time", "UTC+8"],
    "HMT" => ["Heard and McDonald Islands Time", "UTC+5"],
    "HOVT" => ["Khovd Time", "UTC+7"],
    "HST" => ["Hawaii Standard Time", "UTC-10"],
    "ICT" => ["Indochina Time", "UTC+7"],
    "IDT" => ["Israel Daylight Time", "UTC+3"],
    "IOT" => ["Indian Ocean Time", "UTC+3"],
    "IRDT" => ["Iran Daylight Time", "UTC+4:30"],
    "IRKT" => ["Irkutsk Time", "UTC+9"],
    "IRST" => ["Iran Standard Time", "UTC+3:30"],
    "IST" => ["Israel Standard Time", "UTC+2"],
    "JST" => ["Japan Standard Time", "UTC+9"],
    "KGT" => ["Kyrgyzstan time", "UTC+6"],
    "KOST" => ["Kosrae Time", "UTC+11"],
    "KRAT" => ["Krasnoyarsk Time", "UTC+7"],
    "KST" => ["Korea Standard Time", "UTC+9"],
    "LHST" => ["Lord Howe Standard Time", "UTC+10:30"],
    "LINT" => ["Line Islands Time", "UTC+14"],
    "MAGT" => ["Magadan Time", "UTC+12"],
    "MART" => ["Marquesas Islands Time", "UTC-9:30"],
    "MAWT" => ["Mawson Station Time", "UTC+5"],
    "MDT" => ["Mountain Daylight Time (North America)", "UTC-6"],
    "MET" => ["Middle European Time Same zone as CET", "UTC+1"],
    "MEST" => ["Middle European Saving Time Same zone as CEST", "UTC+2"],
    "MHT" => ["Marshall Islands", "UTC+12"],
    "MIST" => ["Macquarie Island Station Time", "UTC+11"],
    "MIT" => ["Marquesas Islands Time", "UTC-9:30"],
    "MMT" => ["Myanmar Time", "UTC+6:30"],
    "MSK" => ["Moscow Time", "UTC+4"],
    "MST" => ["Malaysia Standard Time", "UTC+8"],
    "MUT" => ["Mauritius Time", "UTC+4"],
    "MYT" => ["Malaysia Time", "UTC+8"],
    "NCT" => ["New Caledonia Time", "UTC+11"],
    "NDT" => ["Newfoundland Daylight Time", "UTC-2:30"],
    "NFT" => ["Norfolk Time", "UTC+11:30"],
    "NPT" => ["Nepal Time", "UTC+5:45"],
    "NST" => ["Newfoundland Standard Time", "UTC-3:30"],
    "NT" => ["Newfoundland Time", "UTC-3:30"],
    "NUT" => ["Niue Time", "UTC-11"],
    "NZDT" => ["New Zealand Daylight Time", "UTC+13"],
    "NZST" => ["New Zealand Standard Time", "UTC+12"],
    "OMST" => ["Omsk Time", "UTC+7"],
    "ORAT" => ["Oral Time", "UTC+5"],
    "PDT" => ["Pacific Daylight Time (North America)", "UTC-7"],
    "PET" => ["Peru Time", "UTC-5"],
    "PETT" => ["Kamchatka Time", "UTC+12"],
    "PGT" => ["Papua New Guinea Time", "UTC+10"],
    "PHOT" => ["Phoenix Island Time", "UTC+13"],
    "PHT" => ["Philippine Time", "UTC+8"],
    "PKT" => ["Pakistan Standard Time", "UTC+5"],
    "PMDT" => ["Saint Pierre and Miquelon Daylight time", "UTC-2"],
    "PMST" => ["Saint Pierre and Miquelon Standard Time", "UTC-3"],
    "PONT" => ["Pohnpei Standard Time", "UTC+11"],
    "PST" => ["Pacific Standard Time (North America)", "UTC-8"],
    "PT" => ["Pacific Standard Time (North America)", "UTC-8"],
    "PYST" => ["Paraguay Summer Time (South America)[6]", "UTC-3"],
    "PYT" => ["Paraguay Time (South America)", "UTC-4"],
    "RET" => ["Reunion Time", "UTC+4"],
    "ROTT" => ["Rothera Research Station Time", "UTC-3"],
    "SAKT" => ["Sakhalin Island time", "UTC+11"],
    "SAMT" => ["Samara Time", "UTC+4"],
    "SAST" => ["South African Standard Time", "UTC+2"],
    "SBT" => ["Solomon Islands Time", "UTC+11"],
    "SCT" => ["Seychelles Time", "UTC+4"],
    "SGT" => ["Singapore Time", "UTC+8"],
    "SLST" => ["Sri Lanka Time", "UTC+5:30"],
    "SRT" => ["Suriname Time", "UTC-3"],
    "SST" => ["Singapore Standard Time", "UTC+8"],
    "SYOT" => ["Showa Station Time", "UTC+3"],
    "TAHT" => ["Tahiti Time", "UTC-10"],
    "THA" => ["Thailand Standard Time", "UTC+7"],
    "TFT" => ["Indian/Kerguelen", "UTC+5"],
    "TJT" => ["Tajikistan Time", "UTC+5"],
    "TKT" => ["Tokelau Time", "UTC+13"],
    "TLT" => ["Timor Leste Time", "UTC+9"],
    "TMT" => ["Turkmenistan Time", "UTC+5"],
    "TOT" => ["Tonga Time", "UTC+13"],
    "TVT" => ["Tuvalu Time", "UTC+12"],
    "UCT" => ["Coordinated Universal Time", "UTC"],
    "ULAT" => ["Ulaanbaatar Time", "UTC+8"],
    "UTC" => ["Coordinated Universal Time", "UTC"],
    "UYST" => ["Uruguay Summer Time", "UTC-2"],
    "UYT" => ["Uruguay Standard Time", "UTC-3"],
    "UZT" => ["Uzbekistan Time", "UTC+5"],
    "VET" => ["Venezuelan Standard Time", "UTC-4:30"],
    "VLAT" => ["Vladivostok Time", "UTC+10"],
    "VOLT" => ["Volgograd Time", "UTC+4"],
    "VOST" => ["Vostok Station Time", "UTC+6"],
    "VUT" => ["Vanuatu Time", "UTC+11"],
    "WAKT" => ["Wake Island Time", "UTC+12"],
    "WAST" => ["West Africa Summer Time", "UTC+2"],
    "WAT" => ["West Africa Time", "UTC+01"],
    "WEDT" => ["Western European Daylight Time", "UTC+1"],
    "WEST" => ["Western European Summer Time", "UTC+1"],
    "WET" => ["Western European Time", "UTC"],
    "WIT" => ["Western Indonesian Time", "UTC+7"],
    "WST" => ["Western Standard Time", "UTC+8"],
    "YAKT" => ["Yakutsk Time", "UTC+10"],
    "YEKT" => ["Yekaterinburg Time", "UTC+6"],
    "Z" => ["Zulu Time (Coordinated Universal Time)", "UTC"]
  }

class ConvertController < ApplicationController
  respond_to :html, :xml, :json, :yaml

  def current()
    if (params[:time] != nil)
        redirect_to URI.encode('/' + params[:time])
        return
    end

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
    @response['out_timezone'] = "UTC"
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
     'in_timezone_utc' => '',
     'out_time' => '',
     'out_timezone' => '',
     'current_time' => false
    }

    params[:format] = ''

    if (params[:requirements])
      params[:format] = params[:requirements][:ext] || ""
    end

    if (request.method == "OPTIONS")
      try_render({"ok" => 1})
      return
    end

    params[:time] = params[:time] || DateTime.now.strftime("%H:%M")
    timezone = request.headers['x-timezone'] || params[:timezone] || getTimezone()

    #parse the params time
    # => 1100
    # => 11
    # => 1
    if (timezone != nil)
      # timezone.gsub!(/[\s+]/, "")

      # format all non 0-9, a-z, :, -, + characters
      params[:time].gsub!(/([^0-9A-Za-z:-\\+\s-]+)/, "")

      if (!params[:time].include?(":"))
        time = params[:time].sub(/([a-zA-Z\+\-\s]{2,}([0-9]+)?)+/, "")

        puts time

        if (time.length < 1)
          #try_render({"error" => "invalid date"})
          #return
          time = DateTime.now.strftime("%H%M")
          params[:time] = "#{time} #{params[:time]}"
          @response['current_time'] = true
        elsif (time.sub(/(\s)+/, "").length > 4)
          time = time.sub(/(\s)+/, "")
          time = time.slice(0, 4)
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

        params[:time].gsub!(time, newtime)
      end

      in_timezone = params[:time]

      if (params[:time].match(/(am|pm)(\s{0}?)/i))
        # => 15:00pm | 15:00am
        params[:time].sub!(/(am|pm)/i){$1 + " "}
        in_timezone = params[:time].gsub(/(pm|am)/i, "")
      end
      
      matches = in_timezone.match(/([a-zA-Z\+\-\s]{2,}([0-9]+)?)+/)
      @response['in_timezone'] = matches == nil ? "UTC" : matches[0].upcase
      @response['in_timezone'].gsub!(/[\s]/, "")

      in_timezone_utc = ""
      $TIMEZONES.each do |key, array|
        if (params[:time].match(/#{key}/i) != nil)
          in_timezone_utc = array[1]
          params[:time].gsub!(/#{key}/i, "")
          break
        end
      end

      #detect what timezone they sent
      #whole numbers mean minutes offset from UTC
      #accepted other formats:
      # => (GMT/UTC)+/-0-14
      timezone.gsub!(/[\s]/, "")
      if (timezone.match(/[^0-9\+-]/))
        if (!timezone.match(/(-|\+)/))
          tmp_zone = timezone.gsub(/[^0-9-]/, "")
          timezone_index = timezone.index(tmp_zone)

          if (tmp_zone.to_i > 0)
            timezone.insert(timezone_index, "+")
          end
        end

        zone = DateTime.parse("1/1/1970 12am #{timezone}").to_i
        timezone = -(zone / 60)
      end

      timezone = timezone.to_i / 1.0
      if (timezone != 0)
        timezone = timezone.to_i / 60.0
      end
      
      timezone_str = convert_timezone(timezone)
      
      begin
        date_time = DateTime.parse(params[:time] + " " + in_timezone_utc)
        in_time = date_time.to_i
        int_time_offset = date_time.utc_offset

        if (@response['current_time'])
        	mod = @response['in_timezone'].gsub(/[^0-9\+\-]/, "").to_i
        	final_time = in_time + (mod * 3600) * 2
        else
        	timezone_diff = timezone * 3600
          final_time = in_time + timezone_diff
        end

        date = Time.at(final_time).utc()
        # in_timezone_utc = convert_timezone(int_time_offset / 3600.0)

        @response['in_time'] = date_time.to_formatted_s(:time)
        @response['out_time'] = date.to_formatted_s(:time)
        @response['out_date'] = date.strftime("%Y-%-m-%-d")
        @response['in_timezone_utc'] = (in_timezone_utc)
        @response['out_timezone'] = ("UTC" + timezone_str).gsub(/\./, ':')
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

  def convert_timezone(corrected_timezone)
    floored = corrected_timezone.floor
    decimal = corrected_timezone - floored
    minutes = (decimal * 60).floor
    timezone = (corrected_timezone < 0 ? "" : "+") + (floored.to_s + (minutes == 0 ? "" : ":" + minutes.to_s))
    return timezone
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