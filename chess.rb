require_relative "pieces.rb"
require "colorize"
require 'byebug'

class BadMove < RuntimeError
end


class Board
  attr_accessor :grid, :cursor

  def initialize(set_up_now = true)
    @grid = Array.new(8) {Array.new(8)}
    @cursor = [6,3]
    set_up if set_up_now
  end

  def entire_color(hue)
    grid.flatten.compact.select{|el| el.color == hue}
  end

  def in_check?(hue)
    other_color = hue == :white ? :black : :white
    king_pos = entire_color(hue).find{|el| el.is_a? King}.pos
    entire_color(other_color).any? { |piece| piece.possible_moves.include? king_pos }
  end

  def checkmate?(hue)
    entire_color(hue).all? do |piece|
      piece.valids.empty?
    end
  end

  def dup_board
    dupped_board = Board.new(false)
    grid.flatten.compact.each do |old_piece|
      new_piece = old_piece.class.new(old_piece.pos.dup, dupped_board, old_piece.color)
      dupped_board[new_piece.pos] = new_piece
    end
    dupped_board
  end

  def move(start, end_pos)
    raise BadMove.new "No piece" if self[start].nil?
    piece = self[start]
    #retry or something
    # if self[start].valid_moves?(end_pos)
    if piece.valids.include? end_pos
      move!(start, end_pos)
      # self[end_pos] = self[start]
      # self[end_pos].pos = end_pos
      # self[start] = nil
    else
      raise BadMove.new "Can't move there!"
      #retry or something
    end
  end

  def move!(start, end_pos)
    piece = self[start]
    self[end_pos] = piece
    piece.pos = end_pos
    self[start] = nil
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
    @grid[0][0] = Rook.new([0,0], self, :black)
    @grid[0][1] = Knight.new([0,1], self, :black)
    @grid[0][2] = Bishop.new([0,2], self, :black)
    @grid[0][3] = Queen.new([0,3], self, :black)
    @grid[0][4] = King.new([0,4], self, :black)
    @grid[0][5] = Bishop.new([0,5], self, :black)
    @grid[0][6] = Knight.new([0,6], self, :black)
    @grid[0][7] = Rook.new([0,7], self, :black)
  end

  def [](pos)
    @grid[pos.first][pos.last]
  end

  def []=(pos, value)
    @grid[pos.first][pos.last] = value
  end

  def occupied?(pos_check)
    !!self[pos_check]
  end

  def on_board?(new_pos)
    new_pos[0] >= 0 && new_pos[0] <= 7 && new_pos[1] >= 0 && new_pos[1] <= 7
  end

  def render
    puts '  0  1  2  3  4  5  6  7'
    grid.each_with_index do |array, row|
      print "#{row}" + " "
      array.each_with_index do |piece, col|
        if cursor == [row, col]
          print piece.nil? ? " . ".black.on_white : piece.render.black.on_white + "  ".black.on_white
        else # not cursor position
          if piece
            print piece.render + "  "
          else
            print " . "
          end
        end

      end
      puts " "
    end
  end
end
# b = Board.new
# b.move([6,5], [5,5])
# b.move([1,4],[3,4])
# b.move([6,6],[4,6])
# b.move([0,3],[4,7])
# b.render
# p b.checkmate?(:white)
