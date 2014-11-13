require "pry"

module Reference
  WINNING_LINES = [[1,2,3], [4,5,6], [7,8,9], [1,4,7], [2,5,8], [3,6,9], [1,5,9], [3,5,7]]
end

class Player

  def initialize
  end

  def place_a_piece(board, empty_positions)
    begin
      puts "Choose a position (from 1 to 9) to place a piece:"
      position = gets.chomp.to_i
    end until empty_positions.include?(position)
    board[position] = "X"
  end  

end

class Computer

  include Reference

  def initialize
  end

  def two_in_a_row(hsh, mrkr)
    if hsh.values.count(mrkr) == 2
      hsh.select{|k,v| v == ' '}.keys.first
    else
      false
    end
  end

  def place_a_piece(board, empty_positions)
    attack_position = nil
    defend_position = nil
    WINNING_LINES.each do |line|
      attack_position = two_in_a_row({ line[0]=>board[line[0]], line[1]=>board[line[1]], line[2]=>board[line[2]] }, "O")
      break if attack_position
    end
    WINNING_LINES.each do |line|
      defend_position = two_in_a_row({ line[0]=>board[line[0]], line[1]=>board[line[1]], line[2]=>board[line[2]] }, "X")
      break if defend_position
    end

    position = attack_position || defend_position || empty_positions.sample 
    board[position] = "O"
  end

end

class Board

  attr_accessor :board

  def initialize
    @board = {}
    (1..9).each { |position| @board[position] = " " }
    @board
  end 

  def draw_board
    system 'clear'
    puts "     |     |     "
    puts "  #{board[1]}  |  #{board[2]}  |  #{board[3]}  "
    puts "     |     |     "
    puts "-----+-----+-----"
    puts "     |     |     "
    puts "  #{board[4]}  |  #{@board[5]}  |  #{@board[6]}  "
    puts "     |     |     "
    puts "-----+-----+-----"
    puts "     |     |     "
    puts "  #{board[7]}  |  #{board[8]}  |  #{board[9]}  "
    puts "     |     |     "
  end

  def empty_positions
    board.select { |k, v| v == " " }.keys
  end

end

class TicTacToe

  include Reference
  attr_accessor :board

  def initialize 
    @board_object = Board.new
    @player = Player.new
    @computer = Computer.new
    self.board = @board_object.board
  end

  def run
    @board_object.draw_board
    begin 
      @player.place_a_piece(board, @board_object.empty_positions)
      @computer.place_a_piece(board, @board_object.empty_positions) if !check_winner
      @board_object.draw_board
    end until check_winner || it_is_a_tie?
  end

  def it_is_a_tie?
    if @board_object.empty_positions.length == 1
      board[@board_object.empty_positions.first] = "X"
      if !check_winner
        puts "It's a tie!"
        return true 
      end
    end
  end

  def check_winner
    WINNING_LINES.each do |line|
      if board.values_at(*line).count('X') == 3
        puts "You won!"
        return "Player" 
      end
      if board.values_at(*line).count('O') == 3
        puts "Computer won!"
        return "Computer" 
      end
    end
    nil
  end

end

TicTacToe.new.run


