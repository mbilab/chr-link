var readFile = process.argv[2];
var writeFile = process.argv[3];
var fs = require("fs");
var encoding = 'utf-8';
var NUMBER = 16;	//chromosome number
var list = [];		//listing all the genome type
var buckets = new Array(NUMBER);

for(var i = 0; i < NUMBER; i++) {
  buckets[i] = new Array();
}

if(readFile == undefined || writeFile == undefined) {
  console.log("\nError: Required read filename and write filename.");
  console.log("\nUsage:\n\tnode [create_genome_list.js] [reading filename] [writing file name]\n");
}
else {
  fs.readFile(readFile, encoding, function(err, data) {
    if(err) throw err;
    var array = data.split('\n');	//all the data is in array split with line by line
    var i = 0;
    var line;
    console.log('\nPlease wait ...');
    array.forEach(function(text) {
      if(text) {
	line = text.split('\t');
	line[1] = number_to_letter(line[1]);
	line[3] = number_to_letter(line[3]);
	list.push(line[1] + '_' + line[0] + '\t' + line[3] + '_' + line[2]);
	list.push(line[3] + '_' + line[2] + '\t' + line[1] + '_' + line[0]);
      }
    });


    console.log('\nSorting the array ...');
    list.sort();
    console.log('\nConverting letter to string in the head');
    while(list[i]) {
      line = list[i].split('\t');
      genes1 = line[0].split('_');
      genes2 = line[1].split('_');
      genes1[0] = letter_to_number(genes1[0]);
      genes2[0] = letter_to_number(genes2[0]);
      list[i] = genes1[0] + '\t' + genes1[1] + '\t' + genes2[0] + '\t' + genes2[1];
      i++;
    }

    console.log('\nStart to write to file ...');	
    fs.open(writeFile, 'w', function(err, fd) {
      list.forEach(function(element) {
        fs.write(fd, element + "\n");
      });
    });
    console.log('\nFinish.');	
  });
}


function number_to_letter(number) {
  switch(number) {
    case '1':
      return 'A';
      break;
    case '2':
      return 'B';
      break;
    case '3':
      return 'C';
      break;
    case '4':
      return 'D';
      break;
    case '5':
      return 'E';
      break;
    case '6':
      return 'F';
      break;
    case '7':
      return 'G';
      break;
    case '8':
      return 'H';
      break;
    case '9':
      return 'I';
      break;
    case '10':
      return 'J';
      break;
    case '11':
      return 'K';
      break;
    case '12':
      return 'L';
      break;
    case '13':
      return 'M';
      break;
    case '14':
      return 'N';
      break;
    case '15':
      return 'O';
      break;
    case '16':
      return 'P';
      break;
    default:
      break;
  }
}
function letter_to_number(letter) {
  switch(letter) {
    case 'A':
      return '1';
      break;
    case 'B':
      return '2';
      break;
    case 'C':
      return '3';
      break;
    case 'D':
      return '4';
      break;
    case 'E':
      return '5';
      break;
    case 'F':
      return '6';
      break;
    case 'G':
      return '7';
      break;
    case 'H':
      return '8';
      break;
    case 'I':
      return '9';
      break;
    case 'J':
      return '10';
      break;
    case 'K':
      return '11';
      break;
    case 'L':
      return '12';
      break;
    case 'M':
      return '13';
      break;
    case 'N':
      return '14';
      break;
    case 'O':
      return '15';
      break;
    case 'P':
      return '16';
      break;
    default:
      break;
  }
}
