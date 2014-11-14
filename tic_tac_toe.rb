class Player
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def place_a_piece
  end
end

class Human < Player
  def place_a_piece(positions, empty_positions)
    begin
      puts "Choose a position (from 1 to 9) to place a piece:"
      p = gets.chomp.to_i
    end until empty_positions.include?(p)
    positions[p] = "X"
  end  
end

class Computer < Player
  def two_in_a_row(hsh, mrkr)
    if hsh.values.count(mrkr) == 2
      hsh.select{|k,v| v == ' '}.keys.first
    else
      false
    end
  end

  def place_a_piece(positions, empty_positions)
    attack_position = nil
    defend_position = nil
    Game::WINNING_LINES.each do |line|
      attack_position = two_in_a_row({ line[0]=>positions[line[0]], line[1]=>positions[line[1]], line[2]=>positions[line[2]] }, "O")
      break if attack_position
    end
    Game::WINNING_LINES.each do |line|
      defend_position = two_in_a_row({ line[0]=>positions[line[0]], line[1]=>positions[line[1]], line[2]=>positions[line[2]] }, "X")
      break if defend_position
    end

    position = attack_position || defend_position || empty_positions.sample 
    positions[position] = "O"
  end
end

class Board
  attr_accessor :positions

  def initialize
    @positions = { 1 => " ", 2 => " ", 3 => " ", 4 => " ", 5 =>" ",
                   6 => " ", 7 => " ", 8 => " ", 9 => " " }
  end 

  def draw_board
    system 'clear'
    puts "     |     |     "
    puts "  #{positions[1]}  |  #{positions[2]}  |  #{positions[3]}  "
    puts "     |     |     "
    puts "-----+-----+-----"
    puts "     |     |     "
    puts "  #{positions[4]}  |  #{positions[5]}  |  #{positions[6]}  "
    puts "     |     |     "
    puts "-----+-----+-----"
    puts "     |     |     "
    puts "  #{positions[7]}  |  #{positions[8]}  |  #{positions[9]}  "
    puts "     |     |     "
  end

  def empty_positions
    positions.select { |k, v| v == " " }.keys
  end
end

class Game
  WINNING_LINES = [[1,2,3], [4,5,6], [7,8,9], [1,4,7], [2,5,8], [3,6,9], [1,5,9], [3,5,7]]
  attr_accessor :positions

  def initialize 
    @board = Board.new
    @player = Human.new("Jacy")
    @computer = Computer.new("R2RD")
    @positions = @board.positions
  end

  def run
    @board.draw_board
    begin 
      @player.place_a_piece(positions, @board.empty_positions)
      @computer.place_a_piece(positions, @board.empty_positions) if !check_winner
      @board.draw_board
    end until check_winner || it_is_a_tie?
  end

  def it_is_a_tie?
    if @board.empty_positions.length == 1
      positions[@board.empty_positions.first] = "X"
      if !check_winner
        puts "It's a tie!"
        return true 
      end
    end
  end

  def check_winner
    WINNING_LINES.each do |line|
      if positions.values_at(*line).count('X') == 3
        puts "You won!"
        return "Player" 
      end
      if positions.values_at(*line).count('O') == 3
        puts "Computer won!"
        return "Computer" 
      end
    end
    nil
  end

end

Game.new.run


