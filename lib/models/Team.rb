class Team

  attr_reader :id, :name, :players 

  @@all = []

  def initialize(team_data)
    @id = team_data["team_key"]
    @name = team_data["team_name"]
    @players = team_data["players"]

    @@all << self
  end

  def self.all
    @@all
  end

  def self.find_by_name(name)
    @@all.find { |team| team.name == name }
  end

end
