/* eslint-disable no-unused-vars */
/* eslint-disable no-undef */
//****************************//
//Accessory fxns useful for SOA experiment
//Designed by Caroline MYERS, Chaz FIRESTONE, and Justin HALBERDA (Johns Hopkins)
//Written by Caroline MYERS (Johns Hopkins)- [08/29/21]
//Last updated by Caroline MYERS (Johns Hopkins)- [09/30/21]
//****************************//


//////////////////**********************ROTATE STIMULUS***********************//////////////////
function drawStimuli(c,stim, locations) {
   
    var ctx = c.getContext('2d');
    var img = document.createElement('img');
    img.src = 'img/dog.png';
    img.src =stim[0][0];
    ctx.drawImage(img,canvasSizeX/2 - stimulusSizeX/2, canvasSizeY/2 - stimulusSizeY/2, 
        stimulusSizeX,stimulusSizeY);
   // img.src = full_designTargetUp[0].Stimuli[0][0];

//    img.src = stim[0][1]; 

    //ctx.drawImage(img,canvasSizeX/2 - locations[0][0], canvasSizeY/2 - locations[0][1], 
      //  stimulusSizeX,stimulusSizeY);

}



function generateLocs(setSizeInput) {
    Myarray = Array.from(Array(setSizeInput).keys());
    for(let qq = 0; qq < Myarray.length; qq++) {
        Myarray[qq] = [getRandomArbitrary(-100, 100),getRandomArbitrary(-100, 100)];
    }
    return Myarray;
    
}
//console.log(myArray);




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
function getRandomInt(min, max) {
    min = Math.ceil(min);
    max = Math.floor(max);
    return Math.floor(Math.random() * (max - min + 1)) + min;
}




startTime =  new Date().getTime();

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



function getFire(c, searchCondition) {
    if (searchCondition =='downAmongUp') {

        var myoutput = [['img/trash.gif'],['img/cat.gif'],['img/cat.gif']];
        return myoutput;

    } 
    return myoutput;
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

function ISI(c, cueCond) {
    // First get dva

    //const AAADVA = jsPsych.data.get().filter({trial_type: 'virtual-chinrest'}).values()[0]['win_height_deg'];

    var ctx = c.getContext('2d');
    var img = document.createElement('img');

    if (cueCond == 'img/rightcueHorseshoe.png' || cueCond == 'img/leftcueHorseshoe.png') {
        img.src = 'img/nocueHorseshoe.png'; 
   
    } else if (cueCond == 'img/rightcue.png' || cueCond == 'img/leftcue.png') {
        img.src = 'img/nocue.png'; 
    } 

    ctx.drawImage(img,canvasSizeX/2 - stimulusSizeX/2, canvasSizeY/2 - stimulusSizeY/2, 
        stimulusSizeX,stimulusSizeY); 

    
}

//////////////////*************************DRAW CUE********************//////////////////
//DRAW CUE
function drawCue(c,cueCond) {
   
    var ctx = c.getContext('2d');
    var img = document.createElement('img');
    img.src = cueCond; 

    ctx.drawImage(img,canvasSizeX/2 - stimulusSizeX/2, canvasSizeY/2 - stimulusSizeY/2, 
        stimulusSizeX,stimulusSizeY);
}


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






