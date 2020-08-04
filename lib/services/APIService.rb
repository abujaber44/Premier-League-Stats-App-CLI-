class APIService

BASE_URI = "https://apiv2.apifootball.com/?action=get_teams"
@@api_key = ENV["API_KEY"]


def fetch_team_by_id(id)
  uri = URI(BASE_URI + "&team_id=#{id}"+"&APIkey=#{@@api_key}")
  teams = make_request(uri)
   if teams[0]
    Team.new(teams[0])
    else
     puts "Couldn't find a team with that name...".colorize(:red)
    end
end

def fetch_all_teams
  uri = URI(BASE_URI + "&league_id=148"+"&APIkey=#{@@api_key}")
  all_teams = make_request(uri)
  all_teams.each do |team|
    puts team["team_name"]
  end
end 


def make_request(uri)
  response = Net::HTTP.get_response(uri)
  JSON.parse(response.body)
end 

end 
