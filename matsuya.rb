# matsuya.rb

require 'mongo'

class Matsuya
  def initialize
    @client = Mongo::MongoClient.new
    @coll = @client.db('matsuya').collection('stores')
  end

  def close
    @client.close
  end

  def query(lon, lat)
    point = { :type => 'Point', coordinates: [ lon, lat ]}
    query = { :loc => { '$near' => {
          '$geometry' => point, '$maxDistance' => 5000
        }}}
    
    @query_string = "db.stores.find(" + query.to_s + ")"
    return @coll.find(query).to_a
  end

  def query_string
    return @query_string
  end

  def self.gravitypoint(points)
    p points
    lon = points.inject(0) { |m, p| m + p[0] }
    lat = points.inject(0) { |m, p| m + p[1] }
    return lon / points.size ,lat / points.size
  end
end
