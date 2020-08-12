class CLI
  @@teams = {
  "Leicester" => " 2611", "Everton" =>  "2612", "Brighton" =>  "2613", "Southampton" =>  "2614",
  "Bournemouth" =>  "2615", "Chelsea" =>  "2616", "Arsenal" =>  "2617", "Crystal Palace" =>  "2619",
  "West Ham" =>  "2620", "Liverpool" =>  "2621", "Watford" => " 2623", "Manchester City" =>  "2626",
  "Manchester United" =>  "2627", "Tottenham" =>  "2628", "Burnley" =>  "2629", "Newcastle" =>  "2630",
  "Aston Villa" =>  "2632", "Norwich" =>  "2641", "Wolves" =>  "2646", "Sheffield Utd" =>  "2654"
  }

  def run
    system("clear")
    @user_input = nil
    @api = APIService.new

    welcome
      until @user_input == "3"
      main_menu
      end
    end

  def welcome
    puts "*** Welcome to The Premier League Statistics App ***".colorize(:blue)
    "\n"
  end

  def main_menu
    @x = nil 
    puts "To start please choose one of the following:"
    puts "1. Enter a team name"
    puts "2. List all teams"
    puts "3. Exit"

    @user_input = gets.chomp

    if @user_input == "1"
      enter_team_name
    elsif @user_input == "2"
      list_all_teams
    elsif @user_input == "3"
      puts "Goodbye!".colorize(:yellow)
      exit
    else
      puts "Invalid input".colorize(:red)
    end
  end

  def enter_team_name
    print "Please enter a team name ".colorize(:blue)
    input = gets.chomp
      @@teams.each do |team_name, id|
    if input.downcase == team_name.downcase
      @x = id 
      end 
    end 
     if @x != nil 
       @team = @api.fetch_team_by_id(@x)  
       team_menu
     else
       puts "Couldn't find a team with that name...".colorize(:red)
       main_menu
     end 
  end 
    
  def team_menu
     puts "Please choose one of the following:"
     puts "1. Top Scorer"
     puts "2. Oldest or Youngest player"
     puts "3. Display all stats for a specific player"
     puts "4. Return to main menu"

     @user_input_1 = gets.chomp

    if @user_input_1 == "1"
      top_scorer
      return_to_menu
    elsif @user_input_1 == "2"
      youngest_or_oldest_player
      return_to_menu
    elsif @user_input_1 == "3"
      display_stats_for_a_player
    elsif @user_input_1 == "4"
      main_menu
    else
      puts "Invalid input".colorize(:red)
      team_menu
    end
  end 

  def display_stats_for_a_player
    print "please enter a player name or type help to list all players ".colorize(:blue)
    @input = gets.chomp
    if @input != "help" 
      player_info
      return_to_menu
    else 
    @team.players.each do |player|
    puts "#{player["player_name"]}"   
     end 
    puts "Please enter a player name ".colorize(:blue)
    @input = gets.chomp  
      player_info
      return_to_menu
    end    
  end 

  def player_info
    player_info = @team.players.find {|x| x["player_name"].downcase == @input.downcase }
     if player_info == nil 
      puts "The player you entered does not belong to this team".colorize(:red)
     else
     player = JSON.pretty_generate(player_info)
     puts player.colorize(:green)
     end 
  end 

  def list_all_teams
    all_teams = @api.fetch_all_teams
    enter_team_name
  end 

  def return_to_menu
    puts "Press 1 to go back to main menu, 2 for team menu, or 3 to exit".colorize(:yellow)
    input = gets.chomp
    if input == "1"
      main_menu
    elsif input == "2"
      team_menu
    elsif input == "3"
      puts "Goodbye!".colorize(:yellow)
      exit 
    else 
      puts "Invalid input".colorize(:red)
      return_to_menu
    end 
  end    
  
  def top_scorer 
    top_scorer_name = @team.players.max_by {|x| x["player_goals"].to_i}["player_name"].split 
    top_scorer_name_1 = (top_scorer_name[0], top_scorer_name[1] = top_scorer_name[1], top_scorer_name[0]).join(" ")
    top_scorer_goals = @team.players.max_by {|x| x["player_goals"].to_i}["player_goals"]
    puts "#{top_scorer_name_1}. He scored #{top_scorer_goals} goals.".colorize(:green) 
  end 

  def youngest_or_oldest_player
    puts "Please choose one of the following:"
    puts "1. Youngest player"
    puts "2. Oldest player"

    input = gets.chomp
    if input == "1"
      youngest_player
    elsif input == "2"
      oldest_player
    else 
      puts "Invalid input".colorize(:red)
      return_to_menu
    end 
  end 

  def youngest_player
    youngest_player_name = @team.players.min_by {|x| x["player_age"].to_i}["player_name"].split 
    youngest_player_name_1 = (youngest_player_name[0], youngest_player_name[1] = youngest_player_name[1], youngest_player_name[0]).join(" ")
    youngest_player_age = @team.players.min_by {|x| x["player_age"].to_i}["player_age"]
    puts "#{youngest_player_name_1}. He is #{youngest_player_age} years old.".colorize(:green)
  end 

  def oldest_player
    oldest_player_name = @team.players.max_by {|x| x["player_age"].to_i}["player_name"].split
    oldest_player_name_1 = (oldest_player_name[0], oldest_player_name[1] = oldest_player_name[1], oldest_player_name[0]).join(" ")
    oldest_player_age = @team.players.max_by {|x| x["player_age"].to_i}["player_age"]
    puts "#{oldest_player_name_1}. He is #{oldest_player_age} years old.".colorize(:green)
  end 

end 


