class GameOfLife

  attr_accessor :total_cells, :matrix, :cells

  def initialize matrix_size=10
    @matrix, @cells = Matrix.new(matrix_size), []
  end

  def generate_cells
    matrix.structure.each_with_index do |element, x|
      element.each_with_index do |element, y|
        cells << Cell.new(x, y)
      end
    end
  end
end

class Cell

  attr_accessor :x, :y, :alive

  def initialize x, y, alive=false
    @x, @y, @alive = x, y, alive
  end

  def neighbours_among cells
    cells.select do |cell|
      distance_from(cell) <= 2 && distance_from(cell) > 0
    end
  end

  def alive_neighbours_among cells
    neighbours_among(cells).select { |cell| cell.alive }
  end

  def dead_neighbours_among cells
    neighbours_among(cells).select { |cell| cell.dead? }
  end

  def dead?
    !alive
  end

  def distance_from cell
    (cell.x - x).abs + (cell.y - y).abs
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
