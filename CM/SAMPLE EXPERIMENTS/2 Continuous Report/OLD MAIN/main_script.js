/* eslint-disable no-unused-vars */
/* eslint-disable no-undef */
//****************************//
//MGP_v1
//Designed by Caroline MYERS, Chaz FIRESTONE, and Justin HALBERDA (Johns Hopkins)
//Written by Caroline MYERS (Johns Hopkins)- [08/29/21]
//Last updated by Caroline MYERS (Johns Hopkins)- [08/14/22]

//////////////////*************************VARIABLES AND CONSTANTS********************//////////////////
const pilotMode = 0; // 1 for pilot mode on, 0 for pilot mode off
const saveDataToServer = 1;
const c = document.getElementById('myCanvas');
const ctx = c.getContext('2d');
var timeline = [];
let canvasSizeX = c.width;
let canvasSizeY = c.height;
let stimulusSizeX = 100;
let stimulusSizeY = 100;
let canvasMidpointX = canvasSizeX / 2; let canvasMidpointY = canvasSizeY / 2;  
const setSizeMax = 36;
const item_size = 45;
const mask_size =  item_size * 2;
const outerRad = 300;
//////////////////*************************GET PROLIFIC INFO********************//////////////////
const PROLIFICLINK = 'https://app.prolific.co/submissions/complete?cc=1FE217EC';

const numTrialsBreak = 20; // number of trials we give subject before offering a break
const numReps = 90;//30; // we have 4 sessions of 30 reps each. //50;//20;//18;//35; //30 //35 //2
var numMasks = 100;
 

// capture info from Prolific
var subject_id = jsPsych.data.getURLVariable('PROLIFIC_PID');
var study_id = jsPsych.data.getURLVariable('STUDY_ID');
var session_id = jsPsych.data.getURLVariable('SESSION_ID');

if (typeof subject_id == 'undefined') {
    subject_id = Date.now();
}

if (typeof study_id == 'undefined') {
    study_id = 'MGP_v1';
}

if (typeof session_id == 'undefined') {
    session_id = 'today';
}

if (typeof subject_id !== 'string') {
    subject_id = subject_id.toString();
}


jsPsych.data.addProperties({
    subject_id: subject_id,
    study_id: study_id,
    session_id: session_id,
});


//////////////////*************************PRELOAD AND DEFINE OUR STIM********************//////////////////

const allMasks = [];
for(let ii = 1; ii <= numMasks; ii++) {
   allMasks.push(['img/mask' + ii.toString() + '.png']);
}


const trialTypes = ['color-precision2','many-guess-6'];

//const possibleRadii2 = [130, 160, 190, 220, 270];
//const possibleRadii2 = [125, 140, 160, 180, 200];
const possibleRadii2 = [outerRad, outerRad - mask_size, outerRad - (mask_size*2),outerRad - (mask_size*3)];//[90, 105,125, 140, 155, 170, 185,200];

const otherPreloadImages =  [['img/trainingExtraEasy.png'],
['img/TaskInstructions2.png'],['img/TaskInstructions1.png'],['img/trainingMedium.png'],['img/trainingEasy.png'],
['img/trainingHard.png'],['img/endTraining.png']];


const instructionImgs = ['img/training1.png','img/training2.png','img/training3.png','img/training4.png','img/training5.png','img/training6.png'];

const allImgs = allMasks.concat(otherPreloadImages);

var preload = {
    type: 'preload',
    images: allImgs,
    show_detailed_errors: true
    
};
timeline.push(preload);

var possibleColors = range(0, 359);
var possibleRotations = range(0, 359);
possibleLocations = range(0, setSizeMax -1); //setSizeMax - 1;

var factors = { 
    dispTime: [1], //[0,16,33,66,132],
    MYTRIALTYPE2: ['color-precision2','many-guess-6'],
   
};

var training_factors = { 
    dispTime: [100, 300, 300, 150, 16],

};

const dispTimesTraining = [1000, 1000, 500, 132, 16]; //[600, 300, 300, 150, 16];
const setSizesTraining = [1,3,5,10,36];
const maskDispTimesTraining = [0, 1000, 500, 132, 132];//[600, 300, 300, 150, 150];


var full_design = jsPsych.randomization.factorial(factors, numReps); //2
var training_design = jsPsych.randomization.factorial(training_factors, 1);


var totalNumTrials = full_design.length;


// A function to get 36 colors, 10 degrees

//const me = generateColorsMaxMin(36,10, 10, 400);
//////////////////*************************MAIN T2: ISI 1********************//////////////////
// Quickly adding in our cute randomization of the rotation of the circle!
//FIRST TRAINING
training_design[0].MYTRIALTYPE2 ='color-precision2';
training_design[1].MYTRIALTYPE2 = ['many-guess-6'];
training_design[2].MYTRIALTYPE2 = ['many-guess-6'];
training_design[3].MYTRIALTYPE2 = ['many-guess-6'];
training_design[4].MYTRIALTYPE2 = ['many-guess-6'];

for(let kk = 0; kk < 5; kk++) {
    if (training_design[kk].MYTRIALTYPE2 == 'color-precision2') {
        training_design[kk].dispDur = dispTimesTraining[kk];
        training_design[kk].dispTime = dispTimesTraining[kk];
        training_design[kk].positions = 0;
        training_design[kk].respWheelRot = jsPsych.randomization.sampleWithoutReplacement(possibleRotations, 1)[0];
       // training_design[kk].item_size = item_sizeBig,
       // full_design[jj].targetColor = [jsPsych.randomization.sampleWithoutReplacement(possibleColors, 1)[0]];
       // full_design[ll].mask = [jsPsych.randomization.sampleWithReplacement(allMasks, 36)];
       training_design[kk].radius2 = 0;
       training_design[kk].colors = generateColorsMaxMin(1,10, 360/36, 360);
       training_design[kk].setSize = 1;
        training_design[kk].instructionImg = instructionImgs[kk];
    } else {
        training_design[kk].dispDur = dispTimesTraining[kk];
        training_design[kk].dispTime = dispTimesTraining[kk];
        training_design[kk].setSize = setSizesTraining[kk];
        training_design[kk].positions = jsPsych.randomization.sampleWithoutReplacement(possibleLocations, training_design[kk].setSize);
        training_design[kk].colors = generateColorsMaxMin(training_design[kk].setSize,10, 360/training_design[kk].setSize, 360);
        training_design[kk].mask = [jsPsych.randomization.sampleWithReplacement(allMasks, training_design[kk].setSize)];
        training_design[kk].maskdispTime = maskDispTimesTraining[kk];
        training_design[kk].instructionImg = instructionImgs[kk];
        training_design[kk].item_size = item_size,
    training_design[kk].respWheelRot = jsPsych.randomization.sampleWithoutReplacement(possibleRotations, 1)[0];
    training_design[kk].instructionImg = instructionImgs[kk];
    training_design[kk].dispTime = dispTimesTraining[kk];

    training_design[kk].radius2 = jsPsych.randomization.sampleWithReplacement(possibleRadii2, setSizeMax);
   // training_design[kk].targetColor = [jsPsych.randomization.sampleWithoutReplacement(possibleColors, 1)[0]];

}
}










//for(let jj = 0; jj < full_design.length; jj++) {
//    full_design[jj].MYTRIALTYPE2 = [jsPsych.randomization.sampleWithReplacement(trialTypes, 1)];
//}

for(let ll = 0; ll < full_design.length; ll++) {

    if (full_design[ll].MYTRIALTYPE2 == 'color-precision2') {
        full_design[ll].dispDur = 1000;
        //full_design[ll].positions = jsPsych.randomization.sampleWithoutReplacement(possibleLocations, 36);
        full_design[ll].respWheelRot = jsPsych.randomization.sampleWithoutReplacement(possibleRotations, 1)[0];
       //full_design[ll].targetColor = [jsPsych.randomization.sampleWithoutReplacement(possibleColors, 1)[0]];
        full_design[ll].mask = [jsPsych.randomization.sampleWithReplacement(allMasks, 1)];
        full_design[ll].radius2 = 0;
        full_design[ll].colors = [jsPsych.randomization.sampleWithoutReplacement(possibleColors, 1)[0]];
        full_design[ll].setSize = 1;
    } else {
        full_design[ll].dispDur = 16;
        full_design[ll].positions = jsPsych.randomization.sampleWithoutReplacement(possibleLocations, 36);
        full_design[ll].respWheelRot = jsPsych.randomization.sampleWithoutReplacement(possibleRotations, 1)[0];
       // full_design[jj].targetColor = [jsPsych.randomization.sampleWithoutReplacement(possibleColors, 1)[0]];
        full_design[ll].mask = [jsPsych.randomization.sampleWithReplacement(allMasks, 36)];
        full_design[ll].radius2 = jsPsych.randomization.sampleWithReplacement(possibleRadii2, 9);
        full_design[ll].colors = generateColorsMaxMin(36,10, 360/36, 360);
        full_design[ll].setSize = 36;
        full_design[ll].item_size = item_size;
        
    }
}
    /////LABEL TRAINING TRIAL TYPES

training_design[0].MYTRIALTYPE2 ='color-precision2';
training_design[1].MYTRIALTYPE2 = 'many-guess-6';
training_design[2].MYTRIALTYPE2 = ['many-guess-6'];
training_design[3].MYTRIALTYPE2 = ['many-guess-6'];
training_design[4].MYTRIALTYPE2 = ['many-guess-6'];

var getDate = new Date();
var weekday = new Array(7);
weekday[0] = 'Sunday';
weekday[1] = 'Monday';
weekday[2] = 'Tuesday';
weekday[3] = 'Wednesday';
weekday[4] = 'Thursday';
weekday[5] = 'Friday';
weekday[6] = 'Saturday';
var todayDate = weekday[getDate.getDay()];
if (pilotMode == 0) {
    timeline.push({
        type: 'fullscreen',
        fullscreen_mode: true
    });
}
// 01: HELLO
var intro_T1_Welcome = {
    type: 'html-keyboard-response', // this is the plugin we're using. We can do this because we have the js library.
    stimulus: `What a beautiful ${todayDate} to do some awesome science! </p> <p>  </p><p> </p>
    By completing this survey or questionnaire, you are consenting to be in this research study. </p>
    Your participation is voluntary and you can stop at any time.<p> [Press any key to continue] </p>`
};
timeline.push(intro_T1_Welcome);
var targetInstructions1General = {
    type: 'html-keyboard-response',
    stimulus: `
    <div style='width: 1000px;'>
    <div style='float: center;'><img src='img/TaskInstructions1.png'></img>
    </div>
    `,
    stimulus_duration: 10000,
    trial_duration: 10000,
    response_ends_trial: false,
};
if (pilotMode == 0) {
    timeline.push(targetInstructions1General);
}
var targetInstructionsGeneral1Cont = {
    type: 'html-keyboard-response',
    stimulus: `
    <div style='width: 1000px;'>
    <div style='float: center;'><img src='img/TaskInstructions1.png'></img>
    </div>
    `,
};
timeline.push(targetInstructionsGeneral1Cont);
var targetInstructions2General = {
    type: 'html-keyboard-response',
    stimulus: `
    <div style='width: 1000px;'>
    <div style='float: center;'><img src='img/TaskInstructions2.png'></img>
    </div>
    `,
    stimulus_duration: 10000,
    trial_duration: 10000,
    response_ends_trial: false,
};
if (pilotMode == 0) {
    timeline.push(targetInstructions2General);
}
var targetInstructionsGeneral2Cont = {
    type: 'html-keyboard-response',
    stimulus: `
    <div style='width: 1000px;'>
    <div style='float: center;'><img src='img/TaskInstructions2.png'></img>
    </div>
    `,
};
timeline.push(targetInstructionsGeneral2Cont);
var targetInstructions3General = {
    type: 'video-keyboard-response',
    stimulus: [
       'video/TaskInstructions3.mp4'
    ],
    response_ends_trial: true,
    width: 900,
    height: 900,
    autoplay: true,
    // choices: "NO_KEYS",
    trial_ends_after_video: false,
};
timeline.push(targetInstructions3General);
//////////////////*************************FAMILIARIZATION PERIOD********************//////////////////
 //////////////////*************************FAMILIARIZATION PERIOD********************//////////////////
//FAMILIARIZATION T1: INSTRUCTIONS
var trainingInstructions = {
    type: 'image-keyboard-response',
    stimulus: jsPsych.timelineVariable('instructionImg'),
    post_trial_gap: 50
};
//FAMILIARIZATION T2: TASK
var trainingTrial = {
    timeline: [{
        type: jsPsych.timelineVariable('MYTRIALTYPE2'), 
        set_size: jsPsych.timelineVariable('setSize'),
        radius2: jsPsych.timelineVariable('radius2'),
        which_test: 0,
        min_difference: 10,//20,
       display_time: jsPsych.timelineVariable('dispTime'),
        item_positions: jsPsych.timelineVariable('positions'),
        spinAmt: jsPsych.timelineVariable('respWheelRot'),
        delay_time: 0, //Time before probe appears'
        delay_start: 1000, // 1000 Delay before starting trial
        mask_display_time: jsPsych.timelineVariable('maskdispTime'),
        color_wheel_spin: true,
        click_to_start: true,
        maskArray: jsPsych.timelineVariable('mask'),
        feedback: false,
        num_placeholders: setSizeMax,
        //item_size: item_size,
        mask_size: mask_size,
        possibleRadii2: possibleRadii2,
        item_colors: jsPsych.timelineVariable('colors'),
        on_finish: function (data) {
            data.CMDispTime = jsPsych.timelineVariable('dispTime');
            data.maskArray = jsPsych.timelineVariable('mask'),
            data.maskRotation = jsPsych.timelineVariable('maskRotation'),
            data.item_positions = jsPsych.timelineVariable('positions'),
            data.task = 'training';
        }
    }]
};
// INITIALIZE TRAINING TIMELINE
var training = {
    timeline: [trainingInstructions,trainingTrial],
    timeline_variables: training_design,
    repetitions: 0,
    randomize_order: false
};
timeline.push(training);
var endTraining = {
    type: 'image-keyboard-response',
    stimulus: [
        'img/endTraining.png'],
    response_ends_trial: true,
    width: 900,
    height: 900,
    trial_ends_after_video: false,
};
timeline.push(endTraining);
//////////////////*************************FIXATION/ITI********************//////////////////
var trial_count = 0;
var main_T1_Fix = {
    type: 'html-keyboard-response',
    stimulus: '<div style="font-size:60px;"> </div>',
    render_on_canvas: true,
    canvas_size: [canvasSizeX,canvasSizeY],
    data: {
        task: 'fixation'
    },
    on_start: function(main_T1_Fix) {
        trial_count++;
        if (trial_count % numTrialsBreak == 0) {
            main_T1_Fix.stimulus =  `Wow! You've completed ${trial_count} out of ${totalNumTrials} trials! </p> <p>  </p><p> Take a quick break, then press any key when you're ready to continue.`
        }
        else if (trial_count % numTrialsBreak !== 0) {  
            main_T1_Fix.trial_duration = 500,
            main_T1_Fix.choices = jsPsych.NO_KEYS,
            main_T1_Fix.stimulus = '';   
        }
    }
};
//////////////////*************************MAIN T2: STIMULI********************//////////////////
var main_T2_Guess = {
    timeline: [{
        type: jsPsych.timelineVariable('MYTRIALTYPE2'), 
        item_colors: jsPsych.timelineVariable('colors'),
        set_size: jsPsych.timelineVariable('setSize'),
        display_time: jsPsych.timelineVariable('dispDur'),
        which_test: 0,
        radius2: jsPsych.timelineVariable('radius2'),
        min_difference: 10,//20,
        click_to_start: true,
        item_positions: jsPsych.timelineVariable('positions'),
        spinAmt: jsPsych.timelineVariable('respWheelRot'),
        delay_time: 0, //Time before probe appears'
        //delay_start: 1000, // 1000 Delay before starting trial
        mask_display_time: 150, //132
        color_wheel_spin: true,
        num_placeholders: setSizeMax,
        maskArray: jsPsych.timelineVariable('mask'),
        feedback: false,
       // item_size: item_size,
        mask_size: mask_size,
        possibleRadii2: possibleRadii2,
        on_finish: function (data) {
            data.CMDispTime = jsPsych.timelineVariable('dispDur');
            data.randomSpinAmount = jsPsych.timelineVariable('respWheelRot');
            data.maskArray = jsPsych.timelineVariable('mask');
            data.item_positions = jsPsych.timelineVariable('positions'),
            data.task = 'main';
            data.mainTask = jsPsych.timelineVariable('MYTRIALTYPE2');
        }
    }]
};

var shuffledArray = jsPsych.randomization.shuffle([main_T1_Fix,main_T2_Guess]);
//////////////////*************************MAIN T5: STIMULI********************//////////////////
// MAIN TIMELINE
var mainExperiment = {
    timeline: shuffledArray,
    timeline_variables: full_design,
    repetitions: 0,
    randomize_order: true
};
timeline.push(mainExperiment);
//////////////////*************************SAVE DATA FXN********************//////////////////
function saveData(name, data){
    var xhr = new XMLHttpRequest();
    xhr.open('POST', 'write_data.php'); // 'write_data.php' is the path to the php file described above.
    xhr.setRequestHeader('Content-Type', 'application/json');
    xhr.send(JSON.stringify({filename: name, filedata: data}));
}
//////////////////*************************INIT AND SAVE EXPERIMENT DATA********************//////////////////
var endQuestion = {
    type: 'survey-text',
    questions: [
        {prompt: 'Thank you! You are almost done! Is there anything we should know about your participation in this experiment today?'}
    ],
};
timeline.push(endQuestion);
if (saveDataToServer == 1) {
    jsPsych.init({
        timeline: timeline,
        randomize_order: true,
        repetitions: 0, //5
        case_sensitive_responses: false,
        // save data to server
        on_finish: function(){ saveData(subject_id, jsPsych.data.get().csv()),
        document.body.innerHTML = `
        <p> 
        <div style='width: 700px;'>
        <div style='float: center;'><img src='img/yay.png'></img>
        </div>
        <center> Thank you for completing the experiment! You're a star! </p>
        </p> Please wait. You will be automatically redirected back to Prolific in 10 seconds. </p>
        </p> <strong>Please do not click out of this page or close this tab. </strong> </p>
        <p>Thank you! </center>  </p>
        `;
        document.documentElement.style.textAlign = 'center';

        setTimeout(function () { location.href = PROLIFICLINK; }, 10000);
        }
    });
}
if (saveDataToServer == 0) {
    jsPsych.init({
        timeline: timeline,
        randomize_order: true,
        override_safe_mode: true,
        on_finish: function () {
            jsPsych.data.displayData('csv');
            jsPsych.data.get().localSave('csv','mydata.csv');
        }
    });
}
