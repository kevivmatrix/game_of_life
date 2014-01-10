require "rspec"
require "debugger"
require "./game_of_life.rb"

describe "game of life" do
  context 'initialize game' do
    context 'matrix' do
      context 'game should start with matrix of 10 if not provided' do
        let(:game_of_life) { GameOfLife.new }
        it "should return a matrix object" do
          game_of_life.matrix.should be_a Matrix
        end
        it "should create a matrix with size of 10" do
          game_of_life.matrix.size.should eq 10
        end
      end
      context 'game should start with given matrix size if provided' do
        let(:game_of_life) { GameOfLife.new 25 }
        it "should create a matrix with size of 25" do
          game_of_life.matrix.size.should eq 25
        end
      end
    end
  end

  context 'start game' do
    let(:game_of_life) { GameOfLife.new(5) }
    let(:generate_cells) { game_of_life.generate_cells }
    let(:cells) { game_of_life.cells }
    it "should create 25 cells" do
      expect { generate_cells }.to change(cells, :count).by(25)
    end
    context 'x and y for each cell should be set within limits' do
      before do
        game_of_life.generate_cells
      end
      let(:cell) { cells.first }
      let(:x) { cell.x }
      let(:y) { cell.y }
      it "x should not be nil" do
        x.should_not be_nil
      end
      it "y should not be nil" do
        y.should_not be_nil
      end
    end
  end
end

describe "matrix" do
  context "random x and y within matrix" do
    let(:matrix) { Matrix.new(10) }
    let(:x) { matrix.get_x_within_matrix }
    it "should not be nil" do
      x.should_not be_nil
    end
    it "should be less than size of matrix" do
      x.should < 10
    end
    let(:y) { matrix.get_y_within_matrix }
    it "should not be nil" do
      y.should_not be_nil
    end
    it "should be less than size of matrix" do
      y.should < 10
    end
    context 'structure' do
      it "should have be an array" do
        matrix.structure.should be_a Array
      end
      it "should have 10 elements" do
        matrix.structure.count.should eq 10
      end
      it "each element should be an array" do
        matrix.structure[0].should be_a Array
      end
      it "each element should be an array of 10 sub-elements" do
        matrix.structure[0].count.should eq 10
      end
    end
  end
end

describe Cell do
  let(:game_of_life) { GameOfLife.new(10) }
  let(:cell) { Cell.new(1, 1, true) }
  let(:cell1) { Cell.new(1, 2, true) }
  let(:cell2) { Cell.new(2, 2, true) }
  let(:cell3) { Cell.new(2, 1, false) }
  let(:cell4) { Cell.new(1, 0, false) }
  let(:cell5) { Cell.new(3, 2) }
  before do
    game_of_life.cells = [
      cell, cell1, cell2, cell3, cell4, cell5
    ]
  end
  context 'neighbours' do
    it "should equal cell1, cell2, cell3, cell4" do
      cell.neighbours_among(game_of_life.cells).should =~ [cell1, cell2, cell3, cell4]
    end
  end
  context "alive neighbours" do
    it "should return alive neighbour cells - cell1, cell2" do
      cell.alive_neighbours_among(game_of_life.cells).should =~ [cell1, cell2]
    end
  end
  context "dead neighbours" do
    it "should return dead neighbour cells - cell3, cell4" do
      cell.dead_neighbours_among(game_of_life.cells).should =~ [cell3, cell4]
    end
  end
end
