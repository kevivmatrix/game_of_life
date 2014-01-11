require "./ruby/game_of_life.rb"

game = GameOfLife.new(10)
game.generate_cells
game.print_cells
# alive list
game.cells[22].alive = true
game.cells[23].alive = true
game.cells[24].alive = true
game.cells[26].alive = true
game.cells[16].alive = true
game.cells[36].alive = true
# ticks
# game.print_cells
loop do
  game.next_tick
  game.print_cells
  sleep 2
end
