require 'spec_helper'

describe "BeermappingApi" do

	describe "in case of cache miss" do

		before :each do
			Rails.cache.clear
		end

		it "When HTTP GET returns zero entries, empty array is returned" do

			canned_answer = <<-END_OF_STRING
<?xml version='1.0' encoding='utf-8' ?><bmp_locations><location><id></id><name></name><status></status><reviewlink></reviewlink><proxylink></proxylink><blogmap></blogmap><street></street><city></city><state></state><zip></zip><country></country><phone></phone><overall></overall><imagecount></imagecount></location></bmp_locations>
			END_OF_STRING

			stub_request(:get, /.*emptylocation/).to_return(body: canned_answer, headers: { 'Content-Type' => "text/xml" })

    	places = BeermappingApi.places_in("emptylocation")

			expect(places.size).to eq(0)
		end

  	it "When HTTP GET returns one entry, it is parsed and returned" do

    	canned_answer = <<-END_OF_STRING
<?xml version='1.0' encoding='utf-8' ?><bmp_locations><location><id>13307</id><name>O'Connell's Irish Bar</name><status>Beer Bar</status><reviewlink>http://beermapping.com/maps/reviews/reviews.php?locid=13307</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=13307&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=13307&amp;d=1&amp;type=norm</blogmap><street>Rautatienkatu 24</street><city>Tampere</city><state></state><zip>33100</zip><country>Finland</country><phone>35832227032</phone><overall>0</overall><imagecount>0</imagecount></location></bmp_locations>
    	END_OF_STRING

    	stub_request(:get, /.*tampere/).to_return(body: canned_answer, headers: { 'Content-Type' => "text/xml" })

    	places = BeermappingApi.places_in("tampere")

    	expect(places.size).to eq(1)
    	place = places.first
    	expect(place.name).to eq("O'Connell's Irish Bar")
    	expect(place.street).to eq("Rautatienkatu 24")
  	end

		it "When HTTP GET returns many entries, they are returned" do
			canned_answer = <<-END_OF_STRING
<?xml version='1.0' encoding='utf-8' ?><bmp_locations><location><id>8235</id><name>Bryggeriet S.C. Fuglsang</name><status>Brewery</status><reviewlink>http://beermapping.com/maps/reviews/reviews.php?locid=8235</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=8235&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=8235&amp;d=1&amp;type=norm</blogmap><street>Bryggerivej 2</street><city>Haderslev</city><state></state><zip>6100</zip><country>Denmark</country><phone>73 52 61 00</phone><overall>0</overall><imagecount>0</imagecount></location><location><id>8239</id><name>Bryghus Haderslev</name><status>Brewery</status><reviewlink>http://beermapping.com/maps/reviews/reviews.php?locid=8239</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=8239&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=8239&amp;d=1&amp;type=norm</blogmap><street>Sejlstensgyde</street><city>Haderslev</city><state></state><zip>6100</zip><country>Denmark</country><phone>25 56 47 81</phone><overall>0</overall><imagecount>0</imagecount></location></bmp_locations>
			END_OF_STRING

			stub_request(:get, /.*haderslev/).to_return(body: canned_answer, headers: { 'Content-Type' => "text/xml" })

  		places = BeermappingApi.places_in("haderslev")

    	expect(places.size).to eq(2)
		
			place1 = places.first
    	expect(place1.name).to eq("Bryggeriet S.C. Fuglsang")

			place2 = places.last
    	expect(place2.name).to eq("Bryghus Haderslev")

		end
	end

	describe "in case of cache hit" do
		it "When location cached but has no entries, empty array is returned" do

      canned_answer = <<-END_OF_STRING
<?xml version='1.0' encoding='utf-8' ?><bmp_locations><location><id></id><name></name><status></status><reviewlink></reviewlink><proxylink></proxylink><blogmap></blogmap><street></street><city></city><state></state><zip></zip><country></country><phone></phone><overall></overall><imagecount></imagecount></location></bmp_locations>
      END_OF_STRING

      stub_request(:get, /.*emptylocation/).to_return(body: canned_answer, headers: { 'Content-Type' => "text/xml" })
			
			# ensure that data found in cache
      BeermappingApi.places_in("emptylocation")

      places = BeermappingApi.places_in("emptylocation")

      expect(places.size).to eq(0)
    end

		it "When one entry in cache, it is returned" do

      canned_answer = <<-END_OF_STRING
<?xml version='1.0' encoding='utf-8' ?><bmp_locations><location><id>13307</id><name>O'Connell's Irish Bar</name><status>Beer Bar</status><reviewlink>http://beermapping.com/maps/reviews/reviews.php?locid=13307</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=13307&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=13307&amp;d=1&amp;type=norm</blogmap><street>Rautatienkatu 24</street><city>Tampere</city><state></state><zip>33100</zip><country>Finland</country><phone>35832227032</phone><overall>0</overall><imagecount>0</imagecount></location></bmp_locations>
      END_OF_STRING

      stub_request(:get, /.*tampere/).to_return(body: canned_answer, headers: { 'Content-Type' => "text/xml" })
			
			#ensure that data found in cache
			BeermappingApi.places_in("tampere")

      places = BeermappingApi.places_in("tampere")

      expect(places.size).to eq(1)
      place = places.first
      expect(place.name).to eq("O'Connell's Irish Bar")
      expect(place.street).to eq("Rautatienkatu 24")
    end

		it "When many entries cached, they are returned" do
      canned_answer = <<-END_OF_STRING
<?xml version='1.0' encoding='utf-8' ?><bmp_locations><location><id>8235</id><name>Bryggeriet S.C. Fuglsang</name><status>Brewery</status><reviewlink>http://beermapping.com/maps/reviews/reviews.php?locid=8235</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=8235&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=8235&amp;d=1&amp;type=norm</blogmap><street>Bryggerivej 2</street><city>Haderslev</city><state></state><zip>6100</zip><country>Denmark</country><phone>73 52 61 00</phone><overall>0</overall><imagecount>0</imagecount></location><location><id>8239</id><name>Bryghus Haderslev</name><status>Brewery</status><reviewlink>http://beermapping.com/maps/reviews/reviews.php?locid=8239</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=8239&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=8239&amp;d=1&amp;type=norm</blogmap><street>Sejlstensgyde</street><city>Haderslev</city><state></state><zip>6100</zip><country>Denmark</country><phone>25 56 47 81</phone><overall>0</overall><imagecount>0</imagecount></location></bmp_locations>
      END_OF_STRING

      stub_request(:get, /.*haderslev/).to_return(body: canned_answer, headers: { 'Content-Type' => "text/xml" })

			BeermappingApi.places_in("haderslev")

      places = BeermappingApi.places_in("haderslev")

      expect(places.size).to eq(2)

      place1 = places.first
      expect(place1.name).to eq("Bryggeriet S.C. Fuglsang")

      place2 = places.last
      expect(place2.name).to eq("Bryghus Haderslev")

    end
	end

end
