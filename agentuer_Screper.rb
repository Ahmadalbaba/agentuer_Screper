require "nokogiri"
require "open-uri"
require "csv"
require 'resolv-replace'
require 'json'
 require 'net/http'
 require 'uri'
 require 'active_support'

url = "https://t3n.de/firmen/"
page = Nokogiri::HTML(open(url).read)

#Extrahieren  Links von der Homepage, die das Wort (kategorie) enthalten,  da sie Links zu Unternehmen enthalten 

links = page.search("a").map{ |tag|
	case tag.name.downcase
	when "a"
		tag["href"]
	end
}

kategorie_links = []
links.each do |link|
	link = link.to_s
  if link.include? "kategorie"
    kategorie_links << link
   end
end

# Öffnen Seite für jede Kategorie
alle_agenturen = []
e_commerce_agenturen = []
e_commerce_agenturen_linken = []
marketing_agenturen = []
marketing_agenturen_linken = []
entwicklung_design_agenturen = []
entwicklung_design_agenturen_linken = []

kategorie_links.each do |link|
  if link == "https://t3n.de/firmen/kategorie/e-commerce/"
	   #herausfinden, wie viele paginationen die Kategorie enthält
     pagination = Nokogiri::HTML(open(link))
     zahl_pagination = pagination.css("ul.pagination > li > a")
     zahlen = []
     zahl_pagination.each do |zahl|
     zahl =zahl.text
	   zahl=zahl.to_i
	   zahlen << zahl
  end
     i = 1
      while i <= zahlen[zahlen.length-3]
            link = link + "?category=Infrastruktur&page=#{i}"
  		      e_commerce_linken = Nokogiri::HTML(open(link))
  		      agenturen_e_commerce_link = e_commerce_linken.css("li.company__item")
  		      agenturen_e_commerce_link = agenturen_e_commerce_link.to_ary
  	   	    agenturen_e_commerce_link.each do |link_agentur|
  	  		    link_agentur = link_agentur.at_css("a")[:href]
  			      e_commerce_agenturen_linken << link_agentur
            end
           i = i+1
       end
  elsif link == "https://t3n.de/firmen/kategorie/marketing/"
        #herausfinden, wie viele paginationen die Kategorie enthält
        pagination = Nokogiri::HTML(open(link))
        zahl_pagination = pagination.css("ul.pagination > li > a")
        zahlen = []
        zahl_pagination.each do |zahl|
          zahl =zahl.text
          zahl=zahl.to_i
          zahlen << zahl
        end

   i = 1
    while i <= zahlen[zahlen.length-3]
          link = link + "?category=Infrastruktur&page=#{i}"
          marketing_linken = Nokogiri::HTML(open(link))
          agenturen_marketing_link = marketing_linken.css("li.company__item")
          agenturen_marketing_link = agenturen_marketing_link.to_ary
          agenturen_marketing_link.each do |link_agentur|
            link_agentur = link_agentur.at_css("a")[:href]
            marketing_agenturen_linken << link_agentur
          end
         i = i+1
    end
  elsif link == "https://t3n.de/firmen/kategorie/entwicklung-design/"
        #herausfinden, wie viele paginationen die Kategorie enthält
        pagination = Nokogiri::HTML(open(link))
        zahl_pagination = pagination.css("ul.pagination > li > a")
        zahlen = []
        zahl_pagination.each do |zahl|
          zahl =zahl.text
          zahl=zahl.to_i
          zahlen << zahl
        end

   i = 1
    while i <= zahlen[zahlen.length-3]
          link = link + "?category=Infrastruktur&page=#{i}"
          entwicklung_design_linken = Nokogiri::HTML(open(link))
          agenturen_entwicklung_design_link = entwicklung_design_linken.css("li.company__item")
          agenturen_entwicklung_design_link = agenturen_entwicklung_design_link.to_ary
          agenturen_entwicklung_design_link.each do |link_agentur|
            link_agentur = link_agentur.at_css("a")[:href]
            entwicklung_design_agenturen_linken << link_agentur
          end
         i = i+1
    end
	end
end

e_commerce_agenturen_linken.each do |link|
		e_commerce_agenturen_l = Nokogiri::HTML(open(link))
		e_commerce_agenturen_text = e_commerce_agenturen_l.text
		if e_commerce_agenturen_text.include?  "Daten & Kontakt:" 
			 e_commerce_agenturen_l_info_box = e_commerce_agenturen_l.at_css("div.info-box").text
          if (e_commerce_agenturen_l_info_box.include? "www.") || (e_commerce_agenturen_l_info_box.include? "http://") || (e_commerce_agenturen_l_info_box.include? "https://") || (e_commerce_agenturen_l_info_box.include? ".com") || (e_commerce_agenturen_l_info_box.include? ".de")
             e_commerce_agentur_l = e_commerce_agenturen_l.at_css("div.info-box a")[:href]
			       e_commerce_agenturen << e_commerce_agentur_l
          end 
    end
end
e_commerce_agenturen_informant = []
e_commerce_agenturen.each do |e_commerce_agenture|
  if e_commerce_agenture.include? "http://www"
     e_commerce_agenture = e_commerce_agenture.gsub('http://www', 'http://informant.d-1.com/++/www')
     e_commerce_agenturen_informant << e_commerce_agenture
  elsif e_commerce_agenture.include? "https://www"
        e_commerce_agenture = e_commerce_agenture.gsub('https://www', 'http://informant.d-1.com/++/www')
        e_commerce_agenturen_informant << e_commerce_agenture
  elsif e_commerce_agenture.include? "http://"
        e_commerce_agenture = e_commerce_agenture.gsub('http://', 'http://informant.d-1.com/++/www.')
        e_commerce_agenturen_informant << e_commerce_agenture
  elsif e_commerce_agenture.include? "https://"
        e_commerce_agenture = e_commerce_agenture.gsub('https://', 'http://informant.d-1.com/++/www.')
        e_commerce_agenturen_informant << e_commerce_agenture
  end
end

marketing_agenturen_linken.each do |link|
    marketing_agenturen_l = Nokogiri::HTML(open(link))
    marketing_agenturen_text = marketing_agenturen_l.text
    if marketing_agenturen_text.include?  "Daten & Kontakt:" 
       marketing_agenturen_l_info_box = marketing_agenturen_l.at_css("div.info-box").text
       if (marketing_agenturen_l_info_box.include? "www.") || (marketing_agenturen_l_info_box.include? "http://") || (marketing_agenturen_l_info_box.include? "https://") || (marketing_agenturen_l_info_box.include? ".com") || (marketing_agenturen_l_info_box.include? ".de")
           marketing_agentur_l = marketing_agenturen_l.at_css("div.info-box a")[:href]
           marketing_agenturen << marketing_agentur_l
       end
    end
end
marketing_agenturen_informant = []
marketing_agenturen.each do |marketing_agenture|
  if marketing_agenture.include? "http://www"
     marketing_agenture = marketing_agenture.gsub('http://www', 'http://informant.d-1.com/++/www')
     marketing_agenturen_informant << marketing_agenture
  elsif marketing_agenture.include? "https://www"
        marketing_agenture = marketing_agenture.gsub('https://www', 'http://informant.d-1.com/++/www')
        marketing_agenturen_informant << marketing_agenture
  elsif marketing_agenture.include? "http://"
        marketing_agenture = marketing_agenture.gsub('http://', 'http://informant.d-1.com/++/www.')
        marketing_agenturen_informant << marketing_agenture
  elsif marketing_agenture.include? "https://"
        marketing_agenture = marketing_agenture.gsub('https://', 'http://informant.d-1.com/++/www.')
        marketing_agenturen_informant << marketing_agenture
  end
end

entwicklung_design_agenturen_linken.each do |link|
    entwicklung_design_agenturen_l = Nokogiri::HTML(open(link))
    entwicklung_design_agenturen_text = entwicklung_design_agenturen_l.text
    if entwicklung_design_agenturen_text.include?  "Daten & Kontakt:" 
       entwicklung_design_agenturen_l_info_box = entwicklung_design_agenturen_l.at_css("div.info-box").text
       if (entwicklung_design_agenturen_l_info_box.include? "www.") || (entwicklung_design_agenturen_l_info_box.include? "http://") || (entwicklung_design_agenturen_l_info_box.include? "https://") || (entwicklung_design_agenturen_l_info_box.include? ".com") || (entwicklung_design_agenturen_l_info_box.include? ".de")
           entwicklung_design_agentur_l = entwicklung_design_agenturen_l.at_css("div.info-box a")[:href]
           entwicklung_design_agenturen << entwicklung_design_agentur_l
        end
    end
end
entwicklung_design_agenturen_informant = []
entwicklung_design_agenturen.each do |entwicklung_design_agenture|
  if entwicklung_design_agenture.include? "http://www"
    entwicklung_design_agenture = entwicklung_design_agenture.gsub('http://www', 'http://informant.d-1.com/++/www')
    entwicklung_design_agenturen_informant << entwicklung_design_agenture
  elsif entwicklung_design_agenture.include? "https://www"
    entwicklung_design_agenture = entwicklung_design_agenture.gsub('https://www', 'http://informant.d-1.com/++/www')
    entwicklung_design_agenturen_informant << entwicklung_design_agenture
    elsif entwicklung_design_agenture.include? "http://"
    entwicklung_design_agenture = entwicklung_design_agenture.gsub('http://', 'http://informant.d-1.com/++/www.')
    entwicklung_design_agenturen_informant << entwicklung_design_agenture
  elsif entwicklung_design_agenture.include? "https://"
    entwicklung_design_agenture = entwicklung_design_agenture.gsub('https://', 'http://informant.d-1.com/++/www.')
    entwicklung_design_agenturen_informant << entwicklung_design_agenture
  end
end

alle_agenturen = e_commerce_agenturen_informant + marketing_agenturen_informant + entwicklung_design_agenturen_informant
puts e_commerce_agenturen_informant.length
puts marketing_agenturen_informant.length
puts entwicklung_design_agenturen_informant.length

puts alle_agenturen.length


inofrmant_linken_include_json = []
agenturen_linken_uninclude_informant = [] #Links zu Shops, die keine Informant_links haben
array_hash_infos_for_json = []
alle_agenturen.each do |link|
  unless (link.include? ("ä")) || (link.include? ("ü")) || (link.include? ("ö")) || (link.include? (" ")) 
         puts  link 
         url = link
         uri = URI(url)
         begin
          uri = URI.parse(url)
         rescue URI::InvalidURIError
          uri = URI.parse(URI.escape(url))
         end
         res = Net::HTTP.get_response(uri)
         # Status
         message_ = res.message     
        if message_ == "OK" 
           response = Net::HTTP.get(uri)
           x = JSON.parse(response)
           inofrmant_linken_include_json << x
           key_array =[]
           value_array = []
           array_hash_info =[]
           x.each do |key, value|
              unless value.class == Hash 
                    value_array << value
                    key_array << key
              else
                    y = value
                    y.each do |key, value|
                      value_array  << value
                      key_array << key  
                    end
                    key_array = key_array.push('PLZ')  
                    key_array = key_array.push('cityy')
              end
           end
           hash_infos = Hash[key_array.zip(value_array)]
           array_hash_info =[] << hash_infos
           hash_infos.each do |key, value|
             if key == "city" && hash_infos['city'].class != NilClass 
                city_array = hash_infos['city'].split(' ')
                hash_infos['PLZ']= city_array[0]
                hash_infos['cityy']= city_array[1]
                hash_infos.store("PLZ", city_array[0])
                hash_infos.store("cityy", city_array[1])
             end
           end
          hash_infos_for_json ={} 
          if hash_infos['url'].class != NilClass
             hash_infos_for_json['Url'] = hash_infos['url']
          else
             hash_infos_for_json['Url'] = hash_infos['url']
          end
          if hash_infos['document_title'].class != NilClass
             hash_infos_for_json['Agenturname'] = hash_infos['document_title']
          else
             hash_infos_for_json['Agenturname'] = hash_infos['document_title']
          end
          if hash_infos['document_keywords'].class != NilClass
             hash_infos_for_json['Subtitle'] = hash_infos['document_keywords']
          else
              hash_infos_for_json['Subtitle'] = hash_infos['document_keywords']
          end
          if hash_infos['document_description'].class != NilClass
            hash_infos_for_json['Description'] = hash_infos['document_description']
          else
            hash_infos_for_json['Description'] = hash_infos['document_description']
          end
          if hash_infos['legal_page'].class != NilClass
          hash_infos_for_json['legal_page'] = hash_infos['legal_page']
          else
            hash_infos_for_json['legal_page'] = hash_infos['legal_page']
          end
          if hash_infos['contact_page'].class != NilClass
          hash_infos_for_json['Contact'] = hash_infos['contact_page']
          else
            hash_infos_for_json['Contact'] = hash_infos['contact_page']
          end
          if hash_infos['street'].class != NilClass
          hash_infos_for_json['Street'] = hash_infos['street']
          else
            hash_infos_for_json['Street'] = hash_infos['street']
          end
          if hash_infos['PLZ'].class != NilClass
          hash_infos_for_json['Zipcode'] = hash_infos['PLZ']
          else
            hash_infos_for_json['Zipcode'] = hash_infos['PLZ']
          end
          if hash_infos['cityy'].class != NilClass
          hash_infos_for_json['City'] = hash_infos['cityy']
          else
            hash_infos_for_json['City'] = hash_infos['cityy']
          end
          if hash_infos['opengraph_locale'].class != NilClass
             hash_infos_for_json['Country'] = hash_infos['opengraph_locale']
          else
             hash_infos_for_json['Country'] = hash_infos['opengraph_locale']
          end
          if hash_infos['email'].class != NilClass
             hash_infos_for_json['email'] = hash_infos['email']
          else
             hash_infos_for_json['email'] = hash_infos['email']
          end
          if hash_infos['phone_number'].class != NilClass
             hash_infos_for_json['Phone'] = hash_infos['phone_number']
          else
             hash_infos_for_json['Phone'] = hash_infos['phone_number']
          end
          if hash_infos['facebook'].class != NilClass
             hash_infos_for_json['Facebook'] = hash_infos['facebook']
          else
             hash_infos_for_json['Facebook'] = hash_infos['facebook']
          end
          if hash_infos['google_plus'].class != NilClass
             hash_infos_for_json['google plus'] = hash_infos['google_plus']
          else
             hash_infos_for_json['google plus'] = hash_infos['google_plus']
          end
          if hash_infos['twitter'].class != NilClass
             hash_infos_for_json['Twitter'] = hash_infos['twitter']
          else
             hash_infos_for_json['Twitter'] = hash_infos['twitter']
          end
          if hash_infos['xing'].class != NilClass
             hash_infos_for_json['Xing'] = hash_infos['xing']
          else
             hash_infos_for_json['Xing'] = hash_infos['xing']
          end
           if hash_infos['opengraph_image'].class != NilClass
              hash_infos_for_json['opengraph_image'] = hash_infos['opengraph_image']
          else
              hash_infos_for_json['opengraph_image'] = hash_infos['opengraph_image']
          end 
   array_hash_infos_for_json << hash_infos_for_json
   else
     #Links zu Shops, die keine Informant_links haben
     agenturen_linken_uninclude_informant << link
   end
  end
end
  fjson = File.open("Informationen_agenturen.json", 'w')
  fjson.write(array_hash_infos_for_json.to_json)
  fjson.close
 









