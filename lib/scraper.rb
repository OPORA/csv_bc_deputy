require 'open-uri'
require_relative './people'
require 'csv'




class ScrapeMp
  def parser
     csv_file = open('../bc.csv')
     csvmp = CSV.read(csv_file)
     csvmp.shift
     csvmp.each do |mp|
       p mp
       scrape_mp(mp)
     end

    #create_mer()

  end
  # def create_mer
  #   #TODO create mer Sadovoy
  #    names = %w{Антонюк Василь Михайлович}
  #    People.first_or_create(
  #        first_name: names[1],
  #        middle_name: names[2],
  #        last_name: names[0],
  #        full_name: names.join(' '),
  #        deputy_id: 1111,
  #        okrug: nil,
  #        photo_url: "http://www.dubno-adm.rv.ua/UserFiles/Mer_2018_01.jpg",
  #        faction: "Позафракційний",
  #        start_date: "2015-10-20",
  #        end_date:  nil,
  #        created_at: "9999-12-31",
  #        updated_at: "9999-12-31"
  #   )
  # end

  def scrape_mp(mp)

     deputy_id = mp[0]
     last_name = mp[3]
     first_name = mp[1]
     middle_name = mp[2]
     faction = mp[6]
     photo_url = mp[7]

     people = People.first(
         deputy_id: deputy_id,
         first_name: first_name,
         middle_name: middle_name,
         last_name: last_name,
         full_name: last_name + " " + first_name  + " " +  middle_name,
         start_date: "2015-10-20",
         okrug: nil,
         photo_url: photo_url,
         faction: faction
     )

     unless people.nil?
      people.update(end_date:  nil,  updated_at: Time.now)
     else
        People.create(
            deputy_id: deputy_id,
            first_name: first_name,
            middle_name: middle_name,
            last_name: last_name,
            full_name: last_name + " " + first_name  + " " +  middle_name,
            start_date: "2015-10-20",
            okrug: nil,
            photo_url: photo_url,
            faction: faction
        )
     end
  end
end
unless ENV['RACK_ENV']
  ScrapeMp.new
end


