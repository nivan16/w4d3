require "byebug"

# module Greetable
#   def greet
#     "Hello, my name is #{self.name}"
#   end
# end

module Slideable

  attr_reader :HORIZONTAL_DIRS, :DIAGONAL_DIRS

  HORIZONTAL_DIRS = [
    [0, -1], #left
    [0, 1], #right
    [-1, 0], #up
    [1, 0]  #down
  ]

  DIAGONAL_DIRS = [
    [1, 1]
    [-1, -1]
    [-1, 1]
    [1, -1]
  ]

  def horizontal_dirs
    HORIZONTAL_DIRS
  end

  def diagonal_dirs
    DIAGONAL_DIRS
  end

  def moves
    possible_moves = []

    move_dirs.each do |direction|
      dx, dy = direction
      possible_moves += grow_unblocked_moves_in_dir(dx, dy)
    end

    possible_moves
  end

  private

  def move_dirs
    #just a place holder for duck typing!
  end

  def grow_unblocked_moves_in_dir(dx, dy) #[0, 0]
    growing_moves = []

    row, col = @pos

    until !@board.valid_pos([row, col])
      row += dx
      col += dy
      if @board.valid_pos([row, col]) && @board[row, col].is_a?(NullPiece) #maybe double brackets
        growing_moves << [row, col] 
      elsif @board.valid_pos([row, col]) && !@board[row, col].is_a?(NullPiece) && @board[row, col].color != self.color
        growing_moves << [row, col] 
        break
      elsif @board.valid_pos([row, col]) && !@board[row, col].is_a?(NullPiece) && @board[row, col].color == self.color
        break
      end
    end

    growing_moves
  end

end

module Stepable
end

class Rook < Piece# ♜♜♜♜♜♜
  #This class creates the methods used to find the possible positions for a rook
  #And to refer to those pieces in order to move them 
  #VERTICAL_DIRS = []
  include Slideable

  attr_reader :board, :pos, :color

  def initialize(color, board, pos)
    super
    @symbol = :Rook
  end
  
  private

  def move_dirs
    horizontal_dirs
  end
end

class Bishop < Piece
  
  include Slideable
  
  def initialize(color, board, pos)
    super
    @symbol = :Bishop
  end

  private

  def move_dirs
    diagonal_dirs
  end

end

class Queen < Piece
  
  include Slideable
  
  def initialize(color, board, pos)
    super
    @symbol = :Queen
  end

  private

  def move_dirs
    diagonal_dirs + horizontal_dirs
  end

end


class Piece

  attr_accessor :pos, :board, :color
  
  def initialize(color, board, pos)
    @pos = pos
    @board = board
    @color = color
  end
  # attr_reader :piece_value
  # def initialize()
  #   @piece_value = :Piece
  # end
end

class NullPiece
  attr_reader :piece_value
  def initialize 
    @piece_value = :NullPiece
  end
end

class Board
  
  attr_accessor :grid

  def initialize
    @grid = Array.new(8){ Array.new(8) } #two-d array for chess board
    populate_grid
  end

  def populate_grid #later, we will have to fix this so that the correct pieces are in the right places!
    piece_rows = [0, 1, 6, 7]

    (0...@grid.length).each do |row_idx|
      (0...@grid[row_idx].length).each do |ele_idx| #col
        if piece_rows.include?(row_idx)  
          # row_idx, ele_idx
          @grid[row_idx][ele_idx] = Rook.new("Black")   #piece placeholder 
        else 
          @grid[row_idx][ele_idx] = NullPiece.new
        end
      end
    end
  end

  def [](pos)
    row, col = pos
    @grid[row][col]
  end

  def []=(pos, val)
    row, col = pos
    @grid[row][col] = val
  end

  def move_piece(start_pos, end_pos)
    debugger
    start_row, start_col = start_pos
    raise "Off the board!" if !self.valid_pos?(start_pos) || !self.valid_pos?(end_pos)
    raise "No Piece here" if self[start_pos].is_a?(NullPiece) #placeholder
    
    self[end_pos] = self[start_pos]
    self[start_pos] = NullPiece.new
    # You can't capture your own piece!! -Old lady
      #Don't forget to code a raise for this!
    true
  end

  def valid_pos?(pos)
    row, col = pos
    return (0..7).include?(row) && (0..7).include?(col)
  end

  # def add_piece(piece, pos)
  # end

  def print_grid
    @grid.each do |row|
      row.each do |ele|
        print ele.piece_value.to_s + " "
      end
      puts
    end
  end

end









    # #horizontal
    
    # #fill up horizontal dirs ->right moves
    
    # #shovel to horizontal dirs if spot to the right is a null piece
    # row, col = pos
    
    # # until row is invalid || hits a second piece || hits piece on same team
    # until !@board.valid_pos?([row+1, col]) || self.next_pos_opponent?(row+1, col)  
    #   row += 1
    #   HORIZONTAL_DIRS << [row, col]
    # end


    # # #this is for vertical
    # # until !@board.valid_pos?([row, col+1]) || next_pos_opponent?(row, col+1)  
    # #   row += 1
    # #   VERTICAL_DIRS << [row, col]
    # # end
# class Human
#   def play_turn
#     puts "hi"
#   end
# end

# class Robot
#   def play_turn
#     puts "im a robot and doing ai things"
#   end
# end

# class TicTacToe
#   def initialize
#     @player1 = Human.new
#     @player2 = Robot.new
#     @current_player = @player1
#   end

#   def run
#     while #game is not won
#       current_player.play_turn
#       self.switch_player


#     end
#   end

#   def switch_player
#     if @current_player == @player1
#       @current_player = @player2
#     else
#       @current_player == @player1
#     end
#   end

# end