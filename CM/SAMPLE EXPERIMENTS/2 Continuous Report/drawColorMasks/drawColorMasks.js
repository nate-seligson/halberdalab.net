/////////VARS AND CONSTANTS
// we can only draw 8 masks given our color constraints

var _canvasProps = {width: 135, height: 135};
var nCircles = 25;//25
var _options = {spacing: 1, numCircles: nCircles, minSize: 45/2, maxSize: 45/2, higherAccuracy: true};
var _placedCirclesArr = [];
var minDistance = 10;
var maxRelDistance = 20;
var maxDistance = 359;
var minRange = 0;
var maxRange = 359;

////////GET COLORS FOR TRIAL

var maskColors  = generateArrayMaxMin(nCircles,minDistance, maxRelDistance, maxDistance, minRange, maxRange);
///////DRAW
let myColor = [];
for(let jj = 0; jj < maskColors.length; jj++) {
  
    let deg = maskColors[jj];

    var col = getColor(deg);
    // let myColor = [];
    myColor[jj] = 'rgb('
         + (col[0])+','
         + (col[1])+','
         + (col[2])+')';


    
    // return myColor;
    //maskColors = myColor;

}

var myColorArray = myColor;


var _isFilled = function (imgData, imageWidth, x, y) {
    x = Math.round(x);
    y = Math.round(y);
      var a = imgData.data[((imageWidth * y) + x) * 4 + 3];
    return a > 0;
};

var _isCircleInside = function (imgData, imageWidth, x, y, r) {

    let rr = r/2;
    let imageWidth2 = imageWidth;
    // if (!_isFilled(imgData, imageWidth2, x, y)) return false;
    //--use 4 points around circle as good enough approximation
    if (!_isFilled(imgData, imageWidth2, x , y - rr)) return false;
    if (!_isFilled(imgData, imageWidth2, x , y + rr)) return false;
    if (!_isFilled(imgData, imageWidth2, x + rr, y)) return false;
    if (!_isFilled(imgData, imageWidth2, x - rr, y)) return false;

    if (!_isFilled(imgData, imageWidth2, x + rr, y + rr)) return false;
    if (!_isFilled(imgData, imageWidth2, x - rr, y + rr)) return false;
    if (!_isFilled(imgData, imageWidth2, x - rr, y - rr)) return false;
    if (!_isFilled(imgData, imageWidth2, x + rr, y - rr)) return false;
    if (_options.higherAccuracy) {
        //--use another 4 points between the others as better approximation
        var o = Math.cos(Math.PI / 4);
        let oo = o;
        if (!_isFilled(imgData, imageWidth2, x + oo, y + oo)) return false;
        if (!_isFilled(imgData, imageWidth2, x - oo, y + oo)) return false;
        if (!_isFilled(imgData, imageWidth2, x - oo, y - oo)) return false;
        if (!_isFilled(imgData, imageWidth2, x + oo, y - oo)) return false;
    }
    return true;
};

var _touchesPlacedCircle = function (x, y, r) {
    return _placedCirclesArr.some(function (circle) {
        return _dist(x, y, circle.x, circle.y) < circle.size + r + _options.spacing;//return true immediately if any match
    });
};

var _dist = function (x1, y1, x2, y2) {
    var a = x1 - x2;
    var b = y1 - y2;
    return Math.sqrt(a * a + b * b);
};

var _placeCircles = function (imgData) {
    var i = _circles.length;
    _placedCirclesArr = [];
    while (i > 0) {
        i--;
        var circle = _circles[i];
        var safety = 4000;
        while (!circle.x && safety-- > 0) {


            //Pick a random position, uniformly on the larger circle's interior
            let cr = (_canvasProps.width) * Math.sqrt(Math.random());
            let cphi = (2*Math.PI) * Math.random(); 
            
            var x = (cr * Math.cos(cphi)) + (_canvasProps.width/2); // (_canvasProps.width/2) = 90
            var y = (cr * Math.sin(cphi)) + (_canvasProps.width/2); // (_canvasProps.width/2) = 90
           
            if (cr+(45) < (_canvasProps.width/2)) {

                if (!_touchesPlacedCircle(-_canvasProps.width, _canvasProps.width, circle.size)) {
                    circle.x = x;
                    circle.y = y;
                    _placedCirclesArr.push(circle);
                }
            }
        }
    }
};

var _makeCircles = function () {
    var circles = [];
    for (var i = 0; i < _options.numCircles; i++) {
        var circle = {
            color: _colors[i],
            // color: _colors[Math.round(Math.random() * _colors.length)],
            size: _options.minSize + Math.random() * Math.random() * (_options.maxSize - _options.minSize) //do random twice to prefer more smaller ones
       
            // size: _options.minSize
        };
        circles.push(circle);
    }
    circles.sort(function (a, b) {
        return a.size - b.size;
    });
    return circles;
};

/*
 //old version
var _drawCircles = function (ctx) {
    ctx.save();
    $.each(_circles, function (i, circle) {
        var thumbImg = document.createElement('img');
        thumbImg.src = gaborgen(circle.color, 100);
        thumbImg.width = 200;
        thumbImg.height = 200;
        thumbImg.onload = function() {
            ctx.save();
            ctx.beginPath();
            ctx.arc(circle.x, circle.y, circle.size, 0, 2 * Math.PI);
            ctx.closePath();
            ctx.clip();
            ctx.drawImage(thumbImg,circle.x, circle.y);

            ctx.drawImage(thumbImg,circle.x-45, circle.y-45,90,90);
            ctx.drawImage(thumbImg,circle.x+45, circle.y-45,90,90);

            ctx.beginPath();
            //ctx.arc(circle.x, circle.y, circle.size, 0, 2 * Math.PI);
            ctx.clip();
            ctx.closePath();
            ctx.restore();


        };
    });
    ctx.restore();
};
*/
var _drawCircles = function (ctx) {
    ctx.save();
    $.each(_circles, function (i, circle) {
        ctx.fillStyle = circle.color;
        ctx.beginPath();
        ctx.arc(circle.x, circle.y, circle.size, 0, 2 * Math.PI);
        ctx.closePath();
        ctx.fill();
    });

    ctx.restore();
};

/*
//THIS WORKS
var _drawCircles = function (ctx) {
    ctx.save();
    $.each(_circles, function (i, circle) {
        var myimg = new Image();
       // myimg.src = 'gab.png';
       myimg.src = gaborgen(circle.color, 100);
        myimg.width = 1000;
        myimg.height = 1000;
        myimg.onload = function() {
            var pattern = ctx.createPattern(myimg,'repeat');
        ctx.fillStyle = 'blue'; // pattern
        ctx.fillStyle = pattern; // pattern
        ctx.beginPath();
        ctx.arc(circle.x, circle.y, circle.size, 0, 2 * Math.PI);
        ctx.closePath();
        ctx.fill();
        ctx.restore();

        };
        
    });

    ctx.restore();
};
*/



var _drawSvg = function (ctx, path, callback) {
    var img = new Image(ctx);
    img.onload = function () {
        ctx.drawImage(img, 0, 0);
        callback();
    };
    img.src = path;
};

var _colors = myColorArray;
console.log(_colors);
var _circles = _makeCircles();

$(document).ready(function () {
    var $canvas = $('<canvas>').attr(_canvasProps);
    //comment in to see colorginal image: 
   // var $canvas = $('<canvas>').attr(_canvasProps).appendTo('body');
    var $canvas2 = $('<canvas>').attr(_canvasProps).appendTo('body');
    var ctx = $canvas[0].getContext('2d');
    

  
    _drawSvg(ctx, 'circle2.svg', function() {
        var imgData = ctx.getImageData(0, 0, _canvasProps.width, _canvasProps.height);
        _placeCircles(imgData);
        _drawCircles($canvas2[0].getContext('2d'));
        var canvas =  $canvas2[0];

        //this works beautifully
        //  var canvas =  $canvas2[0];
        //  var num = 3;
        //  canvas.toBlob(function(blob) {
        // let imgName = 'mask' +  num.toString();
        //      saveAs(blob, 'pretty image.png');
        //  });

        var dataURL = canvas.toDataURL('image/png', 1.0);
        downloadImage(dataURL, 'mask.png');

        function downloadImage(data, filename = 'untitled.png') {
            var a = document.createElement('a');
            a.href = data;
            a.download = filename;
            document.body.appendChild(a);
            a.click();
        }



    });


});



function getColor(deg) {
    let colorsList = [
        [246,37,111],
        [246,37,110],
        [246,37,109],
        [246,37,107.5],
        [246,37,106],
        [246,37,104.5],
        [246,37,103],
        [246,37.5,102],
        [246,38,101],
        [246,38.5,99.5],
        [246,39,98],
        [246,39.5,96.5],
        [246,40,95],
        [246,41,94],
        [246,42,93],
        [245.5,42.5,91.5],
        [245,43,90],
        [245,44,89],
        [245,45,88],
        [245,46,86.5],
        [245,47,85],
        [244.5,47.5,84],
        [244,48,83],
        [243.5,49,81.5],
        [243,50,80],
        [242.5,51,79],
        [242,52,78],
        [242,53,76.5],
        [242,54,75],
        [241.5,55.5,74],
        [241,57,73],
        [240.5,58,71.5],
        [240,59,70],
        [239,60,69],
        [238,61,68],
        [237.5,62,66.5],
        [237,63,65],
        [236.5,64,64],
        [236,65,63],
        [235.5,66,62],
        [235,67,61],
        [234,68.5,60],
        [233,70,59],
        [232.5,71,57.5],
        [232,72,56],
        [231,73,55],
        [230,74,54],
        [229,75,53],
        [228,76,52],
        [227.5,77,51],
        [227,78,50],
        [226,79,49],
        [225,80,48],
        [224,81,46.5],
        [223,82,45],
        [222,83,44],
        [221,84,43],
        [220,85,42],
        [219,86,41],
        [218,87,40],
        [217,88,39],
        [216,89,38],
        [215,90,37],
        [214,91,36.5],
        [213,92,36],
        [212,93,35],
        [211,94,34],
        [210,95,33],
        [209,96,32],
        [208,97,31],
        [207,98,30],
        [205.5,98.5,29.5],
        [204,99,29],
        [203,100,28],
        [202,101,27],
        [201,102,26.5],
        [200,103,26],
        [198.5,103.5,25],
        [197,104,24],
        [196,105,23.5],
        [195,106,23],
        [194,107,22.5],
        [193,108,22],
        [191.5,108.5,21.5],
        [190,109,21],
        [189,110,20.5],
        [188,111,20],
        [186.5,111.5,19.5],
        [185,112,19],
        [183.5,113,19],
        [182,114,19],
        [181,114.5,19],
        [180,115,19],
        [178.5,115.5,19],
        [177,116,19],
        [176,117,19],
        [175,118,19],
        [173.5,118.5,19],
        [172,119,19],
        [170.5,119.5,19.5],
        [169,120,20],
        [168,120.5,20.5],
        [167,121,21],
        [165.5,121.5,21.5],
        [164,122,22],
        [162.5,123,22.5],
        [161,124,23],
        [160,124.5,24],
        [159,125,25],
        [157.5,125.5,25.5],
        [156,126,26],
        [154.5,126.5,27],
        [153,127,28],
        [152,127.5,28.5],
        [151,128,29],
        [149.5,128.5,30],
        [148,129,31],
        [146.5,129,32],
        [145,129,33],
        [144,129.5,34],
        [143,130,35],
        [141.5,130.5,36],
        [140,131,37],
        [138.5,131.5,38],
        [137,132,39],
        [135.5,132.5,40],
        [134,133,41],
        [133,133.5,42.5],
        [132,134,44],
        [130.5,134,45],
        [129,134,46],
        [127.5,134.5,47],
        [126,135,48],
        [125,135.5,49],
        [124,136,50],
        [122.5,136,51.5],
        [121,136,53],
        [119.5,136.5,54],
        [118,137,55],
        [117,137,56.5],
        [116,137,58],
        [114.5,137.5,59],
        [113,138,60],
        [111.5,138,61.5],
        [110,138,63],
        [109,138.5,64],
        [108,139,65],
        [106.5,139,66.5],
        [105,139,68],
        [103.5,139.5,69.5],
        [102,140,71],
        [101,140,72],
        [100,140,73],
        [98.5,140.5,74.5],
        [97,141,76],
        [95.5,141,77.5],
        [94,141,79],
        [93,141,80],
        [92,141,81],
        [90.5,141.5,82.5],
        [89,142,84],
        [88,142,85.5],
        [87,142,87],
        [85.5,142,88.5],
        [84,142,90],
        [82.5,142,91],
        [81,142,92],
        [80,142,93.5],
        [79,142,95],
        [77.5,142.5,96.5],
        [76,143,98],
        [75,143,99.5],
        [74,143,101],
        [72.5,143,102.5],
        [71,143,104],
        [70,143,105],
        [69,143,106],
        [67.5,143,107.5],
        [66,143,109],
        [65,143,110.5],
        [64,143,112],
        [63,143,113.5],
        [62,143,115],
        [61,143,116],
        [60,143,117],
        [58.5,143,118.5],
        [57,143,120],
        [56,143,121.5],
        [55,143,123],
        [54,143,124.5],
        [53,143,126],
        [52.5,143,127],
        [52,143,128],
        [51,143,129.5],
        [50,143,131],
        [49.5,143,132.5],
        [49,143,134],
        [48,143,135],
        [47,143,136],
        [46.5,143,137.5],
        [46,143,139],
        [46,142.5,140],
        [46,142,141],
        [45.5,142,142.5],
        [45,142,144],
        [45,142,145],
        [45,142,146],
        [45,142,147.5],
        [45,142,149],
        [45.5,141.5,150],
        [46,141,151],
        [46.5,141,152.5],
        [47,141,154],
        [47.5,141,155],
        [48,141,156],
        [49,140.5,157],
        [50,140,158],
        [50.5,140,159],
        [51,140,160],
        [52,139.5,161],
        [53,139,162],
        [54.5,139,163.5],
        [56,139,165],
        [57,138.5,165.5],
        [58,138,166],
        [59.5,138,167],
        [61,138,168],
        [62.5,137.5,169],
        [64,137,170],
        [65.5,137,171],
        [67,137,172],
        [68.5,136.5,173],
        [70,136,174],
        [71.5,135.5,174.5],
        [73,135,175],
        [75,135,176],
        [77,135,177],
        [78.5,134.5,177.5],
        [80,134,178],
        [82,133.5,179],
        [84,133,180],
        [85.5,132.5,180.5],
        [87,132,181],
        [89,132,181.5],
        [91,132,182],
        [92.5,131.5,182.5],
        [94,131,183],
        [96,130.5,183.5],
        [98,130,184],
        [100,129.5,184.5],
        [102,129,185],
        [104,128.5,185.5],
        [106,128,186],
        [107.5,127.5,186.5],
        [109,127,187],
        [111,126.5,187.5],
        [113,126,188],
        [115,125.5,188],
        [117,125,188],
        [119,124,188.5],
        [121,123,189],
        [123,122.5,189],
        [125,122,189],
        [127,121.5,189],
        [129,121,189],
        [130.5,120.5,189.5],
        [132,120,190],
        [134,119,190],
        [136,118,190],
        [138,117.5,190],
        [140,117,190],
        [142,116.5,190],
        [144,116,190],
        [145.5,115,189.5],
        [147,114,189],
        [149,113.5,189],
        [151,113,189],
        [153,112,189],
        [155,111,189],
        [156.5,110,188.5],
        [158,109,188],
        [160,108.5,188],
        [162,108,188],
        [163.5,107,187.5],
        [165,106,187],
        [167,105.5,186.5],
        [169,105,186],
        [170.5,104,185.5],
        [172,103,185],
        [174,102,184.5],
        [176,101,184],
        [177.5,100,183.5],
        [179,99,183],
        [180.5,98,182.5],
        [182,97,182],
        [184,96,181.5],
        [186,95,181],
        [187.5,94,180.5],
        [189,93,180],
        [190.5,92,179],
        [192,91,178],
        [193.5,90,177.5],
        [195,89,177],
        [196.5,88,176],
        [198,87,175],
        [199.5,86,174.5],
        [201,85,174],
        [202.5,84,173],
        [204,83,172],
        [205,82,171],
        [206,81,170],
        [207.5,80,169],
        [209,79,168],
        [210,78,167.5],
        [211,77,167],
        [212.5,76,166],
        [214,75,165],
        [215,73.5,164],
        [216,72,163],
        [217.5,71,162],
        [219,70,161],
        [220,69,159.5],
        [221,68,158],
        [222,67,157],
        [223,66,156],
        [224,64.5,155],
        [225,63,154],
        [226,62,153],
        [227,61,152],
        [228,60,150.5],
        [229,59,149],
        [230,58,148],
        [231,57,147],
        [232,56,146],
        [233,55,145],
        [233.5,54,143.5],
        [234,53,142],
        [235,51.5,141],
        [236,50,140],
        [236.5,49,138.5],
        [237,48,137],
        [237.5,47.5,136],
        [238,47,135],
        [239,46,133.5],
        [240,45,132],
        [240.5,44,131],
        [241,43,130],
        [241.5,42.5,128.5],
        [242,42,127],
        [242.5,41,125.5],
        [243,40,124],
        [243,39.5,123],
        [243,39,122],
        [243.5,38.5,120.5],
        [244,38,119],
        [244.5,37.5,118],
        [245,37,117],
        [245,37,115.5],
        [245,37,114],
        [245.5,37,112.5]
    ];
    return colorsList[deg];
}

