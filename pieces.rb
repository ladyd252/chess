require 'byebug'

class BadMove < RuntimeError
end


class Piece
  attr_accessor :pos, :board, :color
  def initialize(pos,board,color)
    @pos, @board, @color = pos, board, color
  end

  def move_into_check?(end_pos)
    dupped_board = board.dup_board
    dupped_board.move!(pos, end_pos)
    dupped_board.in_check?(color)
  end

  def valids
    possible_moves.select{ |move| !move_into_check?(move) }
  end

  def valid_moves?(next_pos)
    possible_moves.include?(next_pos) && move_into_check?(next_pos) == false
  end

  def inspect
    {:pos => @pos}.inspect
  end

end

class SteppingPiece < Piece
  def possible_moves
    all_possible = []
    all_possible += delta.map {|single_delta| [pos[0] + single_delta[0], pos[1] + single_delta[1]]}

    all_possible = all_possible.select {|move| move[0] >= 0 && move[0] <= 7 && move[1] >= 0 && move[1] <= 7 }
    #check if there's a piece there

    all_possible.reject {|move| board.occupied?(move) && board[move].color == color}
  end
end

class SlidingPiece < Piece

  def possible_moves
    all_possible = []
    delta.each do |s_delta|
      temp_pos = [pos[0] + s_delta[0], pos[1] + s_delta[1]]
      i = 2
      until board.on_board?(temp_pos) == false || (board.occupied?(temp_pos) && board[temp_pos].color == color)
        all_possible << temp_pos
        temp_pos = [pos[0] + s_delta[0] * i, pos[1] + s_delta[1] * i]
        i += 1
      end
    end
    all_possible
  end
end


class King < SteppingPiece
  DELTA = [[1, 1], [1, 0], [1, -1], [0, 1], [0, -1], [-1, 1], [-1, 0], [-1, -1]]

  def render
    @color == :white ? "♔" : "♚"
  end

  def delta
    DELTA
  end
end

class Knight < SteppingPiece
  DELTA = [[1,2],[2,1],[-1,2],[-2,1],[-1,-2],[-2,-1],[1,-2],[2,-1]]

  def render
    @color == :white ? "♘" : "♞"
  end

  def delta
    DELTA
  end
end

class Pawn < Piece
  #black (at top moving down)
  DELTA1 =[[0, 1]]
  #white (at bottom moving up)
  DELTA2 = [[0, -1]]
  def render
    @color == :white ? "♙" : "♟"
  end

  def possible_moves
    all_possible = []
    if @color == :white
      all_possible << [pos[0] - 1, pos[1]] unless board.occupied?([pos[0] - 1, pos[1]])
      all_possible << [pos[0] - 2, pos[1]] if pos[0] == 6 && board.occupied?([pos[0] - 2, pos[1]]) == false
      temp = [pos[0] - 1, pos[1] + 1]
      all_possible << temp if (board.occupied?(temp) && board[temp].color != color)
      temp = [pos[0] - 1, pos[1] - 1]
      all_possible << temp if (board.occupied?(temp) && board[temp].color != color)
    else
      all_possible << [pos[0] + 1, pos[1]] unless board.occupied?([pos[0] + 1, pos[1]])
      all_possible << [pos[0] + 2, pos[1]] if pos[0] == 1 && board.occupied?([pos[0] + 2, pos[1]]) == false
      temp = [pos[0] + 1, pos[1] - 1]
      all_possible << temp if (board.occupied?(temp) && board[temp].color != color)
      temp = [pos[0] + 1, pos[1] + 1]
      all_possible << temp if (board.occupied?(temp) && board[temp].color != color)
    end
    all_possible.select {|move| board.on_board?(move) }
  end
end

class Rook < SlidingPiece
  DELTA = [[1,0], [0,1], [-1,0], [0,-1]]

  def render
    @color == :white ? "♖" : "♜"
  end

  def delta
    # DELTA
    [[1,0], [0,1], [-1,0], [0,-1]]
  end
end

class Bishop < SlidingPiece
  DELTA = [[1,1], [-1,1], [-1,-1], [1,-1]]

  def render
    @color == :white ? "♗" : "♝"
  end

  def delta
    DELTA
  end
end

class Queen < SlidingPiece
  DELTA = [[1,1], [-1,1], [-1,-1], [1,-1],[1,0], [0,1], [-1,0], [0,-1]]

  def render
    @color == :white ? "♕" : "♛"
  end

  def delta
    DELTA
  end
end
