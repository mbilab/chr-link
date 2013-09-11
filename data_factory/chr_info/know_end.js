var fs = require('fs');
var encoding = 'utf-8';
var NUMBER = 16;
var reading_file;
var end = [];
var i;

for(i = 0; i < NUMBER; i++) {
  reading_file = '../original_data/chr/chr' + (i + 1) + '.gene';
  fs.readFile(reading_file, encoding, function(err, data) {
    if(err) throw err;
    var data_list = data.split('\n');
    var line = data_list[data_list.length - 2].split('\t');
    var last = parseInt(line[line.length - 1]);
    fs.open("end", "a", function(err, fd) {
      fs.write(fd, last + ",");
    });
  });
}

