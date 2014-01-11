var GameOfLife = function(matrix_size){
  var _this = this;
  _this.matrix_size = matrix_size;
  _this.matrix = new Matrix(matrix_size);
  _this.cells = new Array();

  _this.generate_cells = function(){
    _.times(_this.matrix.size, function(y){
      var element = new Array(_this.matrix.size);
      _.times(_this.matrix.size, function(x){
        var cell = new Cell(x, y);
        _this.cells.push(cell);
      });
    });
  }
  _this.next_tick = function(){
    _.each(_this.cells, function(cell){
      if (cell.cache_alive && !cell.should_stay_live(_this.cells)) { cell.die(); };
      if (cell.cache_dead() && cell.should_be_reborn(_this.cells)) { cell.reborn(); };
    });
    _.each(_this.cells, function(cell){
      cell.cache_alive = cell.alive;
    });
  }
  _this.print_cells = function(){
    $("#table tbody").html("");
    _.times(_this.matrix_size, function(y){
      $("#table tbody").append("<tr id=" + "y_" + y + ">");
      _.times(_this.matrix_size, function(x){
        var cell = _this.find_cell_by_x_and_y(x, y);
        var text = cell.alive ? "O" : "-";
        $("#y_" + y).append("<td>" + text + "</td>");
      });
      $("#table tbody").append("</tr>")
    });
  }
  _this.find_cell_by_x_and_y = function(x, y){
    return _.find(_this.cells, function(cell){
      return (cell.x == x && cell.y == y);
    });
  }

  return _this;
}

var Cell = function(x, y){
  var _this = this;
  _this.x = x;
  _this.y = y;
  _this.alive = false;
  _this.cache_alive = false;

  _this.neighbours_among = function(cells){
    _this.mates = _.without(cells, _this);
    return _.filter(_this.mates, function(cell){
      return _this.neighbour(cell);
    });
  }
  _this.alive_neighbours_among = function(cells){
    return _.filter(_this.neighbours_among(cells), function(cell){
      return cell.cache_alive;
    });
  }
  _this.dead_neighbours_among = function(cells){
    return _.filter(_this.neighbours_among(cells), function(cell){
      return cell.cache_dead();
    });
  }
  _this.cache_dead = function(){
    return !_this.cache_alive;
  }
  _this.dead = function(){
    return !_this.alive;
  }
  _this.neighbour = function(cell){
    return (_this.distance_from_x(cell) < 2 && _this.distance_from_y(cell) < 2);
  }
  _this.distance_from_x = function(cell){
    return Math.abs(cell.x - x);
  }
  _this.distance_from_y = function(cell){
    return Math.abs(cell.y - y);
  }
  _this.should_stay_live = function(cells){
    // console.log(_this.alive_neighbours_among(cells).length);
    return ((_this.alive_neighbours_among(cells).length == 2 || _this.alive_neighbours_among(cells).length == 3) && _this.alive)
  }
  _this.should_be_reborn = function(cells){
    return (_this.alive_neighbours_among(cells).length == 3 && _this.dead())
  }
  _this.die = function(){
    _this.alive = false;
  }
  _this.reborn = function(){
    _this.alive = true;
  }

  return _this;
}

var Matrix = function(size){
  var _this = this;
  _this.size = size;
  // _this.structure = new Array(_this.size);
  // _.times(_this.size, function(n){
  //   _this.structure[n] = new Array(_this.size);
  // });
  return _this;
}

var game = new GameOfLife(5);
game.generate_cells();

game.cells[0].cache_alive = game.cells[0].alive = true;
game.cells[1].cache_alive = game.cells[1].alive = true;
game.cells[2].cache_alive = game.cells[2].alive = true;
game.cells[3].cache_alive = game.cells[3].alive = true;
game.cells[5].cache_alive = game.cells[5].alive = true;
game.cells[7].cache_alive = game.cells[7].alive = true;
game.cells[8].cache_alive = game.cells[8].alive = true;
game.cells[9].cache_alive = game.cells[9].alive = true;
game.cells[11].cache_alive = game.cells[11].alive = true;
game.cells[20].cache_alive = game.cells[20].alive = true;
game.cells[21].cache_alive = game.cells[21].alive = true;
game.cells[23].cache_alive = game.cells[23].alive = true;

game.print_cells();
timer = setInterval(function(){
  game.next_tick();
  game.print_cells();
}, 5000);
