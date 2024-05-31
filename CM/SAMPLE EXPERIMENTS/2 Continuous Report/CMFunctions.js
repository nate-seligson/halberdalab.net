/* eslint-disable no-unused-vars */
/* eslint-disable no-undef */
//****************************//
//Accessory fxns useful for SOA experiment
//Designed by Caroline MYERS, Chaz FIRESTONE, and Justin HALBERDA (Johns Hopkins)
//Written by Caroline MYERS (Johns Hopkins)- [08/29/21]
//Last updated by Caroline MYERS (Johns Hopkins)- [09/30/21]
//****************************//


function range(start, end) {
    
    var myresult =  Array(end - start + 1).fill().map((_, idx) => start + idx);
    return myresult;
}
var result = range(0, 360); // [9, 10, 11, 12, 13, 14, 15, 16, 17, 18]
//console.log(result);


function getRandomIntInclusive(min, max) {
    min = Math.ceil(min);
    max = Math.floor(max);
    return Math.floor(Math.random() * (max - min + 1)) + min;
}

//////////////////**********************ROTATE STIMULUS***********************//////////////////
function myCircle(c, color, location) {
    var ctx = c.getContext('2d');




    const centerX = canvas.width / 2;
    const centerY = canvas.height / 2;
    const radius = 70;

    ctx.beginPath();
    ctx.arc(centerX, centerY, radius, 0, 2 * Math.PI, false);
    ctx.fillStyle = 'green';
    ctx.fill();
    ctx.lineWidth = 5;
    ctx.strokeStyle = '#003300';
    ctx.stroke();
}


////////
function drawCircle(ctx, x, y, radius, fill, stroke, strokeWidth) {
    ctx.beginPath();
    ctx.arc(x, y, radius, 0, 2 * Math.PI, false);
    if (fill) {
        ctx.fillStyle = fill;
        ctx.fill();
    }
    if (stroke) {
        ctx.lineWidth = strokeWidth;
        ctx.strokeStyle = stroke;
        ctx.stroke();
    }
}

function drawTraining(c,trainLocs1,stim, SS) {
    var ctx = c.getContext('2d');
    locs = trainLocs1;

    for (var ii=0; ii < SS;ii++){
        var image = new Image(); //make a new image object
        image.onload = function() { 
            // ctx.drawImage(image,canvasSizeX/2 - xLoc, canvasSizeY/2 - yLoc, 
            //stimulusSizeX,stimulusSizeY);//D
        };

        image.src = stim[ii];
        xLoc = locs[ii][0];
        yLoc = locs[ii][1];

        ctx.drawImage(image, xLoc,yLoc, 
            stimulusSizeX,stimulusSizeY);

        //ctx.drawImage(image,canvasSizeX/2 - xLoc, canvasSizeY/2 - yLoc, 
        //  stimulusSizeX,stimulusSizeY);

        //print out some things..
        console.log(ii);
        console.log(xLoc), console.log(yLoc);
        console.log(image.src);
        console.log(stim[ii]);

    }
    console.log(locs);
}





function drawSingleStim(c,stim,locs) {
   
    var ctx = c.getContext('2d');
    var img = document.createElement('img');
    //img.src = 'img/cat3.png';
    img.src = stim[0]; 
    XLoc = locs[0][0];
    YLoc = locs[0][1];


    ctx.drawImage(img, XLoc,YLoc, 
        stimulusSizeX,stimulusSizeY);
}


////////works

function drawMultipleStim(c,stim,locs,SS) {
    var ctx = c.getContext('2d');
    for (var ii=0; ii < SS;ii++){
        var image = new Image(); //make a new image object
        image.onload = function() { 
            // ctx.drawImage(image,canvasSizeX/2 - xLoc, canvasSizeY/2 - yLoc, 
            //stimulusSizeX,stimulusSizeY);//D
        };

        image.src = stim[ii];
        xLoc = locs[ii][0];
        yLoc = locs[ii][1];

        ctx.drawImage(image, xLoc,yLoc, 
            stimulusSizeX,stimulusSizeY);

        //ctx.drawImage(image,canvasSizeX/2 - xLoc, canvasSizeY/2 - yLoc, 
        //  stimulusSizeX,stimulusSizeY);

        //print out some things..
        console.log(ii);
        console.log(xLoc), console.log(yLoc);
        console.log(image.src);
        console.log(stim[ii]);

    }
    console.log(locs);
}

/// Generates locations, does not care about spacing
function generateLocsOld(setSizeInput) {
    Myarray = Array.from(Array(setSizeInput).keys());
    for(let qq = 0; qq < Myarray.length; qq++) {
        Myarray[qq] = [getRandomArbitrary(-100, 100),getRandomArbitrary(-100, 100)];
    }
    return Myarray;
    
}





function generateLocsCM(setSizeInput) {
    var flagTest = 'bad'; // the current state of affairs 

    while (flagTest == 'bad') {
        Myarray = Array.from(Array(setSizeInput).keys());
        
        for(let rr = 0; rr < Myarray.length; rr++) {
            Myarray[rr] = [getRandomArbitrary(0, locMax),getRandomArbitrary(0, locMax)];
        }

        flagTest = checkNeighborsCM(Myarray,150,stimulusSizeX,stimulusSizeY);
  
    }

    
    console.log(Myarray);
    return Myarray;
    
}




function checkNeighborsCM(array,threshold, myStimulusSizeX, myStimulusSizeY) {

    var flag = 'good';

    for (var ii=0; ii < array.length;ii++) {

        var currentCenter = array[ii];
        var currentCenterX = array[ii][0] + (.5*myStimulusSizeX); 
        var currentCenterY = array[ii][1] + (.5*myStimulusSizeY);

        var otherCenters = array.filter(function(x) { return x !== currentCenter; });
        //  console.log(currentCenter);
        // console.log(otherCenters);


        for (var oo=0; oo < otherCenters.length;oo++) {
            var compareCenter = otherCenters[oo];
            var compareCenterX = otherCenters[oo][0] + (.5*myStimulusSizeX);
            var compareCenterY = otherCenters[oo][1] + (.5*myStimulusSizeY);

            var distance = Math.sqrt((currentCenterX - compareCenterX)**2 + (currentCenterY - compareCenterY)**2);
            // console.log(distance);
            if (distance < threshold) {
                flag = 'bad';

            }
        }

    }  return flag;

}
//var outputFlag = checkNeighborsCM(array,1);



var bufferVal = 100;
function checkNeighbors(currentCenter, currentRadius, otherCenters, otherRadii,stimSize) {

    //let bad = 0

    var otherCenters = otherCenters.filter(function(x) { return x !== currentCenter; });

    var currentX = currentCenter[0];
    var currentY = currentCenter[1];
    // for(let qq = 0; qq < Myarray.length; qq++) {
    for (var ii=0; ii < otherCenters.length;ii++) {
        var thisCenter = otherCenters[ii];
        var thisRadius = currentRadius;

        var thisX = thisCenter[0];
        var thisY = thisCenter[1];

        var distanceX = (currentX - thisX);
        var distanceY =  (currentY - thisY);
        console.log(otherCenters);
        console.log(distanceX,distanceY);
        //distance = Math.sqrt((currentX - thisX)**2 + (currentY - thisY)**2);
        if (Math.abs(distanceX) < (currentRadius + thisRadius + bufferVal) || Math.abs(distanceY) < (currentRadius + thisRadius + bufferVal)) {
        //if (distance < (currentRadius + thisRadius + bufferVal)) {
            //const ans = 1;
            //return ans,
            
            return ans = 1,
            console.log('redrawing');
        }    else if (distanceX >= (currentRadius + thisRadius + bufferVal) | distanceX >= (currentRadius + thisRadius + bufferVal)) {
            
            //return ans,

            
            return ans = 2,
            console.log('not redrawing');
        }
        //return ans;
        

    }
    return ans;
}



















function checkNeighborsOld(currentCenter, currentRadius, otherCenters, otherRadii) {

    //let bad = 0

    var otherCenters = otherCenters.filter(function(x) { return x !== currentCenter; });

    var currentX = currentCenter[0];
    var currentY = currentCenter[1];
    // for(let qq = 0; qq < Myarray.length; qq++) {
    for (var ii=0; ii < otherCenters.length;ii++) {
        var thisCenter = otherCenters[ii];
        var thisRadius = currentRadius;

        var thisX = thisCenter[0];
        var thisY = thisCenter[1];


        distance = Math.sqrt((currentX - thisX)**2 + (currentY - thisY)**2);
        
        if (distance < (currentRadius + thisRadius + bufferVal)) {
            //const ans = 1;
            //return ans,
            
            return ans = 1,
            console.log('redrawing');
        }    else if (distance >= (currentRadius + thisRadius + bufferVal)) {
            
            //return ans,

            
            return ans = 2,
            console.log('not redrawing');
        }
        //return ans;
        

    }
    return ans;
}

//checkNeighbors(currentCenter, currentRadius, otherCenters, otherRadii)


function getRandomInt(min, max) {
    min = Math.ceil(min);
    max = Math.floor(max);
    return Math.floor(Math.random() * (max - min + 1)) + min;
}



////////

function getRandomArbitrary(min, max) {
    return Math.random() * (max - min) + min;
}

/**
 * Returns a random integer between min (inclusive) and max (inclusive).
 * The value is no lower than min (or the next integer greater than min
 * if min isn't an integer) and no greater than max (or the next integer
 * lower than max if max isn't an integer).
 * Using Math.round() will give you a non-uniform distribution!
 */


function deg2rad(degrees)
{
    var pi = Math.PI;
    return degrees * (pi/180);
}


function shuffleArray(array) {
    let swapTo = array.length; // index of position to swap to
    let swapFrom = null; // index of element randomly selected to swap
    let temp = null; // holds a value for changing assignment
    // work back to front, swapping with random unswapped (earlier) elements
    while (swapTo > 0) {
        // pick an (unswapped) element from the back
        swapFrom = Math.floor(Math.random() * swapTo--);
        // swap it with the current element
        temp = array[swapTo];
        array[swapTo] = array[swapFrom];
        array[swapFrom] = temp;
    }
}







function newFrame() {
    // get the current time
    
    currentTime = new Date().getTime();
    // calculate the elapsed time
    elapsedTime = currentTime - startTime;
    // calculate the position based on the elapsed time
    yPosition = start_y + Math.sin(angle * Math.PI / 180) * speed * elapsedTime;
    xPosition = start_x + Math.cos(angle * Math.PI / 180) * speed * elapsedTime;
    // update the position by changing the ball element's style
    ballElement.style.top = yPosition + 'px';
    ballElement.style.left = xPosition + 'px';
    // console.log(ballElement.style.left);
    // console.log(Math.cos(angle * Math.PI / 180) * speed * elapsedTime)
    // console.log(yPosition);
}



//////////////////**********************DRAW ISI***********************//////////////////
//DRAW ISI

//////////////////*************************DRAW CUE********************//////////////////
//DRAW CUE


//////////////////**********************DRAW STIM***********************//////////////////
//DRAW HORSESHOE
function drawStim(c, letter, locations,cueCond,trialType) {
    var ctx = c.getContext('2d');
    var img = document.createElement('img');

    if (cueCond == 'img/rightcueHorseshoe.png' || cueCond == 'img/leftcueHorseshoe.png') {
        img.src = 'img/nocueHorseshoe.png'; 
   
    } else if (cueCond == 'img/rightcue.png' || cueCond == 'img/leftcue.png') {
        img.src = 'img/nocue.png'; 
    } 

    //img.src = testStimulus; 
    ctx.drawImage(img,canvasSizeX/2 - stimulusSizeX/2, canvasSizeY/2 - stimulusSizeY/2, 
        stimulusSizeX,stimulusSizeY);


    //now text
    ctx.font = '40px arial';
    ctx.textAlign = 'center';
    ctx.textBaseline = 'middle';
    ctx.translate(canvasMidpointX, canvasMidpointY);
    ctx.save();


    // Now here's the tricky part. We need to figure out our trials. 

    if (trialType == 'valid'){

        if (cueCond == 'img/rightcueHorseshoe.png'){
            ctx.translate(topRight[0], topRight[1]);
            ctx.fillText(letter, 0, 0);
            ctx.restore();

        } else if (cueCond == 'img/rightcue.png') {
            ctx.translate(bottomRight[0], bottomRight[1]);
            ctx.fillText(letter, 0, 0);
            ctx.restore();
        } else if (cueCond == 'img/leftcue.png') {
            ctx.translate(bottomLeft[0], bottomLeft[1]);
            ctx.fillText(letter, 0, 0);
            ctx.restore();

        } else if (cueCond == 'img/leftcueHorseshoe.png') {
            ctx.translate(topLeft[0],topLeft[1]);
            ctx.fillText(letter, 0, 0);
            ctx.restore();
        }
    }else if (trialType == 'invalid') {
        ctx.translate(locations[0][0], locations[0][1]);
        ctx.fillText(letter, 0, 0);
        ctx.restore();
    }
}




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

