require "./game_of_life.rb"

game = GameOfLife.new(5)
game.generate_cells
game.print_cells
# alive list
game.cells[0].alive = true
game.cells[1].alive = true
game.cells[2].alive = true
game.cells[3].alive = true
game.cells[5].alive = true
game.cells[7].alive = true
game.cells[8].alive = true
game.cells[9].alive = true
game.cells[11].alive = true
game.cells[20].alive = true
game.cells[21].alive = true
game.cells[23].alive = true

# ticks
# game.print_cells
loop do
  game.next_tick
  game.print_cells
  sleep 2
end
