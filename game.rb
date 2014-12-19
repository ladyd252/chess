require 'byebug'
require_relative 'chess.rb'

class Game
  attr_reader :player1, :player2, :board

  def initialize
    @board = Board.new
    names = get_names
    @player1 = HumanPlayer.new(names.first, :white)
    @player2 = HumanPlayer.new(names.last, :black)
  end

  def get_names
    system("clear")
    puts "Please enter first player's name:"
    player1_name = gets.chomp
    puts "Please enter second player's name:"
    player2_name = gets.chomp
    [player1_name, player2_name]
  end


  def play
    player = player1
    until board.checkmate?(player.color)
      begin
        system("clear")
        positions = player.play_turn(board)
        raise BadMove.new "That's not your piece!!!" if board[positions[0]].color != player.color
        board.move(positions[0], positions[1])
      rescue BadMove => e
        puts e.message
        puts "Please put a valid move"
        puts "hit enter to continue"
        gets.chomp
        retry
      end
      player == player1 ? player = player2 : player = player1
    end

    puts "#{player.name} lost :("
    player == player1 ? player_won = player2 : player_won = player1
    puts "#{player_won.name} won! You rock!!"
  end

end

class HumanPlayer
  attr_reader :color, :name

  def initialize(name, color)
    @color = color
    @name = name
  end

  def play_turn(board)
    # puts "#{name}, which piece do you wish to move?"
    #   start_pos = gets.chomp.split(",").map{|el| el.to_i}
    # puts "#{name}, where would you like to move"
    # end_pos = gets.chomp.split(",").map{|el| el.to_i}
    # pos = [start_pos,end_pos]
    start_pos = [0,0]
    end_pos = [0,0]
    loop do
      begin
        puts "TO MOVE CURSOR: u => up, j => down, h=> left, k => right"
        puts "TO PICK UP PIECE: s"
        puts "TO DROP PIECE: e"
        puts "#{name}, make your move."
        board.render
        system("stty raw -echo")
        option = STDIN.getc
      ensure
        system("stty -raw echo")
      end
      case option
      when "u"
        board.cursor[0] -= 1 if board.cursor[0] > 0
      when "j"
        board.cursor[0] += 1 if board.cursor[0] < 7
      when "h"
        board.cursor[1] -= 1 if board.cursor[1] > 0
      when "k"
        board.cursor[1] += 1 if board.cursor[1] < 7
      when "s"
        start_pos = board.cursor.dup
      when "e"
        end_pos = board.cursor
        break
      when "\e"
        break
      end
      system("clear")
    end
    [start_pos, end_pos]
  end
end


g = Game.new
g.play
