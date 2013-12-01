var resolution = process.argv[2];
var fs = require('fs');
var encoding = 'utf-8';
var filename;
var chr_length = [229308, 811473, 315994, 1530848, 575675, 269503, 1089753, 561199, 435980, 744905, 662927, 1077048, 923492, 783287, 1090013, 946852];
var chr_gene_num = [117, 456, 183, 837, 324, 141, 583, 321, 241, 398, 348, 578, 505, 435, 598, 511];

function app(source, target) {
  filename = "./cor/"+ resolution + "/chr" + source + "-" + target + "_cor.json";
  var list = [];
  fs.readFile(filename, encoding, function(err, data) {
    data = JSON.parse(data);
    for(var i = 0; i < resolution; i++) {
      for(var j = 0; j < resolution; j++) {
	if(data[i][j] != 0) {
	  list.push([i, j]);
	}
      }
    }
    list = JSON.stringify(list);
    fs.open("./cor/" + resolution + "/chr" + source + "-" + target + "_list.json", 'w', function(err, fd) {
      fs.write(fd, list);
    });
  });
}

for(var i = 1; i <= 16; i++) {
  for(var j = 1; j <= 16; j++) {
    app(i, j);
  }
}
