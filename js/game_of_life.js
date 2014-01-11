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
  _this.print_cells = function(table_id){
    $("#" + table_id + " tbody").html("");
    _.times(_this.matrix_size, function(y){
      $("#" + table_id + " tbody").append("<tr id=" + table_id + "y_" + y + ">");
      _.times(_this.matrix_size, function(x){
        var cell = _this.find_cell_by_x_and_y(x, y);
        var class_name = cell.alive ? "live" : "";
        $("#" + table_id + "y_" + y).append("<td class='" + class_name + "' id='" + table_id + "_" + x + "_" + y + "'></td>");
      });
      $("#" + table_id + " tbody").append("</tr>")
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
  _this.live = function(){
    _this.alive = _this.cache_alive = true;
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

$(document).ready(function(){
  var player_1_game = new GameOfLife(10);
  player_1_game.generate_cells();
  player_1_game.print_cells("player_1");

  var player_2_game = new GameOfLife(10);
  player_2_game.generate_cells();
  player_2_game.print_cells("player_2");

  $("#player_1").on("click", "td", function(){
    var x_y = this.id.replace("player_1_", "").split("_");
    var x = x_y[0];
    var y = x_y[1];
    var cell = player_1_game.find_cell_by_x_and_y(x, y);
    cell.live();
    $(this).addClass("live");
  });
  $("#player_2").on("click", "td", function(){
    var x_y = this.id.replace("player_2_", "").split("_");
    var x = x_y[0];
    var y = x_y[1];
    var cell = player_2_game.find_cell_by_x_and_y(x, y);
    cell.live();
    $(this).addClass("live");
  });
  $("#start").click(function(){
    var timer = setInterval(function(){
      player_1_game.next_tick();
      player_2_game.next_tick();
      player_1_game.print_cells("player_1");
      player_2_game.print_cells("player_2");
    }, 1000)
  });
});
