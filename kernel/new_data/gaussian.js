var fs = require("fs");
var encoding = "utf-8";
var resolution = 10;
var start_sigma = 1;
var end_sigma = 1;
var sigma_increment = 1;
var sigma = 1;
/*
var resolution = process.argv[2];
var start_sigma = process.argv[3];
var end_sigma = process.argv[4];
var sigma_increment = process.argv[5];
*/


var filename = "./source_data/r" + resolution + ".json";
var CHR_NUMBER = 16;

var chr_list = [];
for(var i = 1; i <= CHR_NUMBER; i++) {
  chr_list.push(i);
}

if(resolution != null && start_sigma != null && end_sigma != null && sigma_increment) {
  fs.readFile(filename, encoding, function(err, matrix) {
    matrix = JSON.parse(matrix);

    chr_list.forEach(function(source) {
      chr_list.forEach(function(target) {
	var start_row = (target - 1) * resolution;
	var start_col = (source - 1) * resolution;
	var list_filename = "./list/r" + resolution + "_chr" + source + "-" + target + ".json";
	fs.readFile(list_filename, encoding, function(err, list) {
	  list = JSON.parse(list);
	  list.forEach(function(position) {
	    for(var row = start_row; row < start_row + resolution; row++) {
	      for(var col = start_col; col < start_col + resolution; col++) {
		//console.log("before_matrix[" + row + "][" + col + "] = " + matrix[row][col]);
		matrix[row][col] += gaussian(position[0], position[1], col, row, sigma);
		matrix[row][col] = Math.round(10000 * matrix[row][col]) / 10000;
		//console.log("after_matrix[" + row + "][" + col + "] = " + matrix[row][col]);
	      }
	    }
	  });
	  setTimeout(function() {
	    //console.log(matrix);
	    fs.open("./matrix/r" + resolution + "_s" + sigma + ".json", 'w', function(err, fd) {
	      fs.write(fd, "[");
	      matrix.forEach(function(element_row, i) {
		fs.write(fd, "[" + element_row + "]");
		if(i != (CHR_NUMBER * resolution - 1)) {
		  fs.write(fd, ",\n");
		}
	      });
	      fs.write(fd, "\n]");
	    });
	  }, 5000);
	  
	});
      });
    });

  });
}
else {
  console.log("error command");
}


function gaussian(cx, cy, x, y, s) {
  var coefficient = 1 / (s * Math.sqrt(2 * Math.PI));
  var constant = 2 * s * s;
  var distance = Math.pow(cx - x, 2) + Math.pow(cy - y, 2);
  var result = Math.round(10000 * coefficient * Math.exp(-distance / constant)) / 10000;
  //console.log("result = " + result);
  return result;
}


