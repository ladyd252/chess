require_relative "pieces.rb"
require 'byebug'

class Board
  attr_accessor :grid

  def move(start, end_pos)
    if self[start].valid_moves?(end_pos)
      p "its a valid move"
      self[end_pos] = self[start]
      self[start] = nil
    else
    end
  end

  def set_up
    #white pieces
    (0..7).each do |pawn_space|
      @grid[6][pawn_space] = Pawn.new([6,pawn_space],self, :white)
    end
    self[[7,0]] = Rook.new([7,0], self, :white)
    @grid[7][1] = Knight.new([7,1], self, :white)
    @grid[7][2] = Bishop.new([7,2], self, :white)
    @grid[7][3] = Queen.new([7,3], self, :white)
    @grid[7][4] = King.new([7,4], self, :white)
    @grid[7][5] = Bishop.new([7,5], self, :white)
    @grid[7][6] = Knight.new([7,6], self, :white)
    @grid[7][7] = Rook.new([7,7], self, :white)

    #black pieces
    (0..7).each do |pawn_space|
      @grid[1][pawn_space] = Pawn.new([1,pawn_space],self, :black)
    end
    @grid[0][0] = Rook.new([0,0], self, :white)
    @grid[0][1] = Knight.new([0,1], self, :white)
    @grid[0][2] = Bishop.new([0,2], self, :white)
    @grid[0][3] = Queen.new([0,3], self, :white)
    @grid[0][4] = King.new([0,4], self, :white)
    @grid[0][5] = Bishop.new([0,5], self, :white)
    @grid[0][6] = Knight.new([0,6], self, :white)
    @grid[0][7] = Rook.new([0,7], self, :white)
  end

  def [](pos)
    @grid[pos.first][pos.last]
  end

  def []=(pos, value)
    @grid[pos.first][pos.last] = value
  end

  def initialize
    @grid = Array.new(8) {Array.new(8)}
    set_up
  end

  def occupied?(pos_check)
    !!self[pos_check]
  end

  def on_board?(new_pos)
    new_pos[0] >= 0 && new_pos[0] <= 7 && new_pos[1] >= 0 && new_pos[1] <= 7
  end

  def render
    puts '  0  1  2  3  4  5  6  7'
    grid.each_with_index do |row, i|
      print "#{i}" + " "
      row.each do |piece|
        if piece
          print piece.render + "  "
        else
          print " . "
        end
      end
      puts " "
    end
  end
end

b = Board.new
b.move([1,0], [2,0])
b.move([6,1],[5,1])
b.move([2,0], [3,0])
b.move([5,1],[4,1])
b.move([3,0],[4,1])
b. render
# b.render

# p b[[0,0]]
# p b.render
