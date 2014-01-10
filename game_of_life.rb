class GameOfLife

  attr_accessor :total_cells, :matrix, :cells

  def initialize total_cells=5, matrix_size=10
    @total_cells, @matrix, @cells = total_cells, Matrix.new(matrix_size), []
  end

  def generate_cells
    total_cells.times do
      cells << Cell.new(matrix.get_x_within_matrix, matrix.get_y_within_matrix)
    end
  end
end

class Cell

  attr_accessor :x, :y

  def initialize x, y
    @x, @y = x, y
  end

  def neighbours cells
    cells.select do |cell|
      distance_from(cell) <= 2 && distance_from(cell) > 0
    end
  end

  def distance_from cell
    (cell.x - x).abs + (cell.y - y).abs
  end
end

class Matrix

  attr_accessor :size

  def initialize size
    @size = size
  end

  def get_x_within_matrix
    rand(size)
  end

  def get_y_within_matrix
    rand(size)
  end
end
