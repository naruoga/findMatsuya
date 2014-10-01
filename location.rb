# -*- coding: utf-8 -*-

require 'net/http'
require 'uri'
require 'json'

class Location
  def initialize()
    @lon = 139.76
    @lat = 35.68
    @copyright = ''
  end

  def get
    return @lon, @lat
  end

  def copyright
    return @copyright
  end

  def query(srcplace)
    overpass_uri = URI.parse("http://overpass-api.de/api/interpreter")
    
    place = srcplace.strip
    if place =~ /駅$/
      place.sub!(/駅$/, '')
      railway = 'station'
    else
      railway = ''
    end
      
    query = <<"EOS"
[out:json];
(
node
["name"="#{place}"]
["railway"~"#{railway}"]
(29.32907,122.84827,
46.38259,147.20285);
way
["name"="#{place}"]
["railway"~"#{railway}"]
(29.32907,122.84827,
46.38259,147.20285);
);
(._;>;);
out;
EOS

    p query
    http = Net::HTTP.start(overpass_uri.host, overpass_uri.port) {|http|
      response = http.post(overpass_uri.path, query) 
      begin
        result = JSON.parse(response.body)
        p response.code
        p response.body
        elements = result['elements']
      rescue
        return false
      end

      return false if elements.size == 0

      idx = elements.index {|e| e['type'] == 'node' }
      if idx != nil
        @lat = elements[idx]['lat']
        @lon = elements[idx]['lon']
        return true
      else
        return false
      end
    }
  end
end
