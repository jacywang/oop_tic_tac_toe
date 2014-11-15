class Board
  WINNING_LINES = [[1,2,3], [4,5,6], [7,8,9], [1,4,7], 
                   [2,5,8], [3,6,9], [1,5,9], [3,5,7]]
  attr_accessor :board

  def initialize
    @board = {}
    (1..9).each { |position| board[position] = Square.new(" ") }
  end

  def draw
    system "clear"
    puts "     |     |     "
    puts "  #{board[1]}  |  #{board[2]}  |  #{board[3]}  "
    puts "     |     |     "
    puts "-----+-----+-----"
    puts "     |     |     "
    puts "  #{board[4]}  |  #{board[5]}  |  #{board[6]}  "
    puts "     |     |     "
    puts "-----+-----+-----"
    puts "     |     |     "
    puts "  #{board[7]}  |  #{board[8]}  |  #{board[9]}  "
    puts "     |     |     "
  end

  def empty_positions
    board.select { |_, square| square.empty? }.keys
  end

  def mark_square(position, marker)
    board[position].mark(marker)
  end

  def three_markers_in_a_row?(marker)
    WINNING_LINES.each do |line|
      return true if board[line[0]].value == marker &&
                     board[line[1]].value == marker &&
                     board[line[2]].value == marker
    end
    false
  end

  def all_squares_taken?
    empty_positions.length == 0
  end

  def two_in_a_row(hsh, mrkr)
    if hsh.values.count(mrkr) == 2
      hsh.select{|k,v| v == ' '}.keys.first
    else
      false
    end
  end

  def smart_move_position(own_marker, opponent_marker)
    attack_position = nil
    defend_position = nil
    WINNING_LINES.each do |line|
      attack_position = two_in_a_row({ line[0]=>board[line[0]].value, 
                                       line[1]=>board[line[1]].value, 
                                       line[2]=>board[line[2]].value }, own_marker)
     break if attack_position
    end
    WINNING_LINES.each do |line|
      defend_position = two_in_a_row({ line[0]=>board[line[0]].value, 
                                       line[1]=>board[line[1]].value, 
                                       line[2]=>board[line[2]].value }, opponent_marker)
      break if defend_position
    end

    position = attack_position || defend_position || empty_positions.sample
  end
end

class Square
  attr_accessor :value

  def initialize(value)
    @value = value
  end

  def empty?
    value == " "
  end

  def mark(marker)
    self.value = marker
  end

  def to_s
    value
  end
end

class Player
  attr_reader :name, :marker

  def initialize(name, marker)
    @name = name
    @marker = marker
  end
end

class Game
  attr_accessor :board, :human, :computer, :current_player

  def initialize
    @board = Board.new
    @human = Player.new("Jacy", "X")
    @computer = Player.new("R2RD", "O")
    @current_player = @human
  end

  def current_player_mark_square
    if current_player == human
      begin 
        puts "Choose a position (from 1 to 9) to place a piece:"
        position = gets.chomp.to_i
      end until board.empty_positions.include?(position)
    else
      position = board.smart_move_position(computer.marker, human.marker)
    end
    board.mark_square(position, current_player.marker)
  end

  def alternate_player
    if current_player == human
      self.current_player = computer
    else
      self.current_player = human
    end
  end

  def current_player_wins?
    board.three_markers_in_a_row?(current_player.marker)
  end

  def it_is_a_tie?
    board.all_squares_taken?
  end

  def play_again
    begin
      puts "Play again? Y/N"
      player_choice = gets.chomp.upcase
    end until ["Y", "N"].include?(player_choice)
    if player_choice == "Y"
      Game.new.play
    else
      exit
    end
  end

  def play
    loop do
      board.draw
      current_player_mark_square
      if current_player_wins?
        board.draw
        puts "#{current_player.name} won!"
        break
      elsif it_is_a_tie?
        board.draw
        puts "It's a tie!"
        break
      else
        alternate_player
      end
    end
    play_again
  end
end

Game.new.play