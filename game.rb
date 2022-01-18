
require './board.rb'

module GOL
  class Game
    def initialize
      @turns = 0
    end

    def configure
      puts 'Welcome to Conway\'s Game of Life'
      puts "Press Ctrl+C to exit".colorize(:yellow)
      print 'Input the number of board rows: '
      rows = gets.chomp.to_i
      print 'Input the number of board columns: '
      columns = gets.chomp.to_i
      print 'Input the turn speed in seconds: '
      @speed = gets.chomp.to_f

      @board = GOL::Board.new(rows: rows, columns: columns)

      p "speed #{@speed}"
    end

    def start
      print 'Starting Game...'
      while true
        @board.play
        clear_screen
        draw
        @turns += 1
        sleep @speed
      end
    rescue Interrupt => e
      puts "Thanks for playing..."
    end

    private

    TURN_INTERVAL_SECONDS = 5 #1.0/60.0

    def draw
      puts "John Conway's Game of Life".colorize(:yellow)
      puts "Turn #{@turns}".colorize(:yellow)
      @board.to_a.each { |row| puts row.map{ |cell| cell ? alive_cell : dead_cell }.join }
      puts "Press Ctrl+C to exit".colorize(:yellow)
    end
    
    def alive_cell
      " + ".colorize(background: :green)
    end
    
    def dead_cell
      "   ".colorize(background: :white)
    end
    
    def clear_screen
      system(Gem.win_platform? ? 'cls' : 'clear')
    end
  end
end