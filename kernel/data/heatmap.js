var size = 30;
var fs = require('fs');
var encoding = 'utf-8';
var filename;
var chr_length = [229308, 810334, 315994, 1530848, 575675, 269503, 1089753, 561199, 435270, 744905, 662927, 1077048, 923492, 783287, 1090013, 946852];
var chr_gene_num = [117, 456, 183, 837, 324, 141, 583, 321, 241, 398, 348, 578, 505, 435, 598, 511];

function app(source, target) {
  filename = "./link/chr" + source + "-" + target + "_gene_link.json";
  fs.readFile(filename, encoding, function(err, data) {
    var source_length = chr_length[source - 1];
    var target_length = chr_length[target - 1];
    var ppi_cor = [];
    data = JSON.parse(data);
    data.forEach(function (e) {
      var s = Math.round(size * (e.s_start + e.s_end) / (2 * source_length));
      var t = Math.round(size * (e.t_start + e.t_end) / (2 * target_length));
      s = (s == size) ? (s - 1) : (s);
      t = (t == size) ? (t - 1) : (t);
      ppi_cor.push([s, t]);
    });
    var matrix = new Array(size);
    for(var i = 0; i < size; i++) {
      matrix[i] = new Array(size);
    }
    for(var i = 0; i < size; i++) {
      for(var j = 0; j < size; j++) {
	matrix[i][j] = 0;
      }
    }
    ppi_cor.forEach(function(e) {
      var temp_s = e[0];
      var temp_t = e[1];
      matrix[temp_s][temp_t] += 1;
    });
    var list = [];
    for(var i = 0; i < size; i++) {
      for(var j = 0; j < size; j++) {
	if(matrix[i][j] != 0) {
	  list.push([i, j]);
	}
      }
    }
    for(var i = 0; i < size; i++) {
      for(var j = 0; j < size; j++) {
	list.forEach(function(e) {
	  if(i != e[0] && j != e[1]) {
	    matrix[i][j] += gaussian(e[0], e[1], i, j);
	  }
	});
      }
    }

    matrix = JSON.stringify(matrix);
    fs.open("./matrix/chr" + source + "-" + target + "_matrix.json", 'w', function(err, fd) {
      fs.write(fd, matrix);
    });

  });
}
for(var i = 1; i <= 16; i++) {
  for(var j = 1; j <= 16; j++) {
    app(i , j);
  }
}

function gaussian(cx, cy, x, y) {
  var s = 100;
  var a = 1 / (s * Math.sqrt(2 * Math.PI));
  var distance = Math.pow(x - cx, 2) + Math.pow(y - cy, 2);
  var b = -distance / (2 * s * s)
  var f = a * Math.exp(b);
  return f;
}
