class Piece


end

class Board
  def initialize
    @grid = Array.new(8) {Array.new(8)}
  end
end

b = Board.new
p b
