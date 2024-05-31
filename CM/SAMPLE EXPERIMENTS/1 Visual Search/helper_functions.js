/* eslint-disable no-unused-vars */
/* eslint-disable no-undef */

//****************************//
//Helper functions relevant to FLSearchv2.1.7
//Designed by Caroline MYERS, Chaz FIRESTONE, and Justin HALBERDA (Johns Hopkins)
//Written by Caroline MYERS (Johns Hopkins)- [08/29/21]
//Last updated by Caroline MYERS (Johns Hopkins)- [11/16/21]
//****************************//

/***********************************************************************************************
                                        1. SAVE DATA FUNCTION
/***********************************************************************************************/

function saveData(name, data){
    var xhr = new XMLHttpRequest();
    xhr.open('POST', 'write_data.php'); // 'write_data.php' is the path to the php file described above.
    xhr.setRequestHeader('Content-Type', 'application/json');
    xhr.send(JSON.stringify({filename: name, filedata: data}));
}

/***********************************************************************************************
                                    2. DEGREES TO RADIANS (deg2rad)
/***********************************************************************************************/
startTime =  new Date().getTime();

function deg2rad(degrees)
{
    var pi = Math.PI;
    return degrees * (pi/180);
}

/***********************************************************************************************
                                   3. SHUFFLE ARRAY (shuffleArray)
/***********************************************************************************************/
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

/***********************************************************************************************
                              4. CONSTANTLY ROTATE STIMULI (newFrame)
/***********************************************************************************************/
function newFrame() {
    currentTime = new Date().getTime(); // get current timestamp
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

/***********************************************************************************************
                                   5. DRAW AN ISI (ISI)
/***********************************************************************************************/

function ISI(c, cueCond) {
    // First get dva
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

/***********************************************************************************************
                                     6. DRAW CUE (drawCue)
/***********************************************************************************************/
function drawCue(c,cueCond) {
   
    var ctx = c.getContext('2d');
    var img = document.createElement('img');
    img.src = cueCond; 

    ctx.drawImage(img,canvasSizeX/2 - stimulusSizeX/2, canvasSizeY/2 - stimulusSizeY/2, 
        stimulusSizeX,stimulusSizeY);
}

/***********************************************************************************************
                                    7. DRAW HORSESHOE (drawStim)
/***********************************************************************************************/
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






