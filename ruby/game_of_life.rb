class GameOfLife

  attr_accessor :matrix, :cells, :matrix_size

  def initialize matrix_size=10
    @matrix_size, @matrix, @cells = matrix_size, Matrix.new(matrix_size), []
  end

  def generate_cells
    matrix.structure.each_with_index do |element, y|
      element.each_with_index do |element, x|
        @cells << Cell.new(x, y)
      end
    end
  end

  def next_tick
    cells.each do |cell|
      cell.die if cell.cache_alive? && !cell.show_stay_live?(cells)
      cell.reborn if cell.cache_dead? && cell.should_be_reborn?(cells)
    end
    cells.each {|cell| cell.cache_alive = cell.alive}
  end

  def print_cells
    matrix_size.times do |y|
      matrix_size.times do |x|
        cell = find_cell_by_x_and_y(x, y)
        cell.alive? ? print("O") : print("-")
      end
      print "\n"
    end
    print "\n"
  end

  def find_cell_by_x_and_y x, y
    cells.select {|cell| cell.x == x && cell.y == y}.first
  end
end

class Cell

  attr_accessor :x, :y, :alive, :mates, :cache_alive

  def initialize x, y, alive=false
    @x, @y, @alive, @cache_alive = x, y, alive, alive
  end

  def neighbours_among cells
    @mates = cells - [self]
    mates.select do |cell|
      neighbour?(cell)
    end
  end

  def alive_neighbours_among cells
    neighbours_among(cells).select { |cell| cell.cache_alive? }
  end

  def dead_neighbours_among cells
    neighbours_among(cells).select { |cell| cell.cache_dead? }
  end

  def cache_alive?
    cache_alive
  end

  def cache_dead?
    !cache_alive
  end

  def alive?
    alive
  end

  def dead?
    !alive
  end

  def neighbour? cell
    distance_from_x(cell) < 2 && distance_from_y(cell) < 2
  end

  def distance_from_x cell
    (cell.x - x).abs
  end

  def distance_from_y cell
    (cell.y - y).abs
  end

  def show_stay_live? cells
    (alive_neighbours_among(cells).count == 2 ||
      alive_neighbours_among(cells).count == 3) && alive?
  end

  def should_be_reborn? cells
    alive_neighbours_among(cells).count == 3 && dead?
  end

  def die
    @alive = false
  end

  def reborn
    @alive = true
  end
end

class Matrix

  attr_accessor :size, :structure

  def initialize size
    @size = size
    @structure = Array.new(size) { 
      Array.new(size)
    }
  end

  def get_x_within_matrix
    rand(size)
  end

  def get_y_within_matrix
    rand(size)
  end
end
