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
    console.log(data);
    data = JSON.parse(data);
    data.forEach(function (e) {
      var s = (e.s_start + e.s_end) / (2 * source_length);
      var t = (e.t_start + e.t_end) / (2 * target_length);
      ppi_cor.push([s, t]);
    });
    ppi_cor = JSON.stringify(ppi_cor);
    fs.open("./cor/chr" + source + "-" + target + "_cor.json", 'w', function(err, fd) {
      fs.write(fd, ppi_cor);
    });
  });
}

for(var i = 1; i <= 16; i++) {
  for(var j = 1; j <= 16; j++) {
    app(i, j);
  }
}
