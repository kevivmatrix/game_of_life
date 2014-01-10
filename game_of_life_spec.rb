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
  context 'next tick' do
    let(:game_of_life) { GameOfLife.new(3) }
    let!(:generate_cells) { game_of_life.generate_cells }
    let(:cell1) { game_of_life.cells[0] }
    let(:cell2) { game_of_life.cells[1] }
    let(:cell3) { game_of_life.cells[2] }
    let(:cell4) { game_of_life.cells[3] }
    let(:cell5) { game_of_life.cells[4] }
    let(:cell6) { game_of_life.cells[5] }
    let(:cell7) { game_of_life.cells[6] }
    let(:cell8) { game_of_life.cells[7] }
    let(:cell9) { game_of_life.cells[8] }
    before do
      cell1.alive = true
      cell2.alive = true
      cell3.alive = true
      cell4.alive = true
      game_of_life.next_tick
    end
    it "cell1 should live" do
      cell1.alive.should be_true
    end
    it "cell2 should die" do
      cell2.alive.should be_true
    end
    it "cell3 should die" do
      cell3.alive.should be_false
    end
    it "cell4 should die" do
      cell4.alive.should be_false
    end
    it "cell5 should re-live" do
      cell5.alive.should be_false
    end
    it "cell6 should die" do
      cell6.alive.should be_false
    end
    it "cell7 should die" do
      cell7.alive.should be_false
    end
    it "cell8 should die" do
      cell8.alive.should be_false
    end
    it "cell9 should die" do
      cell9.alive.should be_false
    end
    context 'double tick' do
      before do
        game_of_life.next_tick
        game_of_life.next_tick
      end
      it "cell1 should live" do
        cell1.alive.should be_false
      end
      it "cell2 should die" do
        cell2.alive.should be_false
      end
      it "cell3 should die" do
        cell3.alive.should be_false
      end
      it "cell4 should die" do
        cell4.alive.should be_false
      end
      it "cell5 should die" do
        cell5.alive.should be_false
      end
      it "cell6 should die" do
        cell6.alive.should be_false
      end
      it "cell7 should die" do
        cell7.alive.should be_false
      end
      it "cell8 should die" do
        cell8.alive.should be_false
      end
      it "cell9 should die" do
        cell9.alive.should be_false
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
  context 'should live?' do
    context 'law 1 - Any live cell with fewer than two live neighbours dies, as if caused by under-population.' do
      context '0 neighbours' do
        let(:cell) { Cell.new(1,1) }
        let(:cells) { [Cell.new(4, 3, true)] }
        it "should not be alive" do
          cell.should_live_as_per_law_1?(cells).should eq false
        end
      end
      context '1 neighbour' do
        let(:cell) { Cell.new(1,1) }
        let(:cells) { [Cell.new(2, 2, true)] }
        it "should not be alive" do
          cell.should_live_as_per_law_1?(cells).should eq false
        end
      end
      context '2+ neighbours' do
        let(:cell) { Cell.new(1,1) }
        let(:cells) { [Cell.new(2, 2, true), Cell.new(1, 2, true)] }
        it "should not be alive" do
          cell.should_live_as_per_law_1?(cells).should eq true
        end
      end
    end
    context 'law 3 - Any live cell with more than three live neighbours dies, as if by overcrowding.' do
      context '3 or less neighbours' do
        let(:cell) { Cell.new(1,1) }
        let(:cells) { [Cell.new(1, 0, true), Cell.new(0, 1, true), Cell.new(2, 2, true)] }
        it "should not be alive" do
          cell.should_live_as_per_law_3?(cells).should eq true
        end
      end
      context 'more than 3 neighbours' do
        let(:cell) { Cell.new(1,1) }
        let(:cells) { [Cell.new(1, 0, true), Cell.new(0, 1, true), Cell.new(2, 2, true), Cell.new(0, 0, true)] }
        it "should not be alive" do
          cell.should_live_as_per_law_3?(cells).should eq false
        end
      end
    end
    context 'law 4 - Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.' do
      context '3 neighbours' do
        let(:cell) { Cell.new(1,1) }
        let(:cells) { [Cell.new(1, 0, true), Cell.new(0, 1, true), Cell.new(2, 2, true)] }
        it "should not be alive" do
          cell.should_live_as_per_law_4?(cells).should eq true
        end
      end
      context 'neighbours less than 3' do
        let(:cell) { Cell.new(1,1) }
        let(:cells) { [Cell.new(1, 0, true), Cell.new(0, 1, true)] }
        it "should not be alive" do
          cell.should_live_as_per_law_4?(cells).should eq false
        end
      end
      context 'neighbours more than 3' do
        let(:cell) { Cell.new(1,1) }
        let(:cells) { [Cell.new(1, 0, true), Cell.new(0, 1, true), Cell.new(2, 2, true), Cell.new(0, 0, true)] }
        it "should not be alive" do
          cell.should_live_as_per_law_4?(cells).should eq false
        end
      end
    end
  end
  context 'die' do
    let(:cell) { Cell.new(1, 1, true) }
    it "should kill the cell" do
      expect { cell.die }.to change(cell, :alive).from(true).to(false)
    end
  end
  context 'relive' do
    let(:cell) { Cell.new(1, 1) }
    it "should kill the cell" do
      expect { cell.relive }.to change(cell, :alive).from(false).to(true)
    end
  end
end
