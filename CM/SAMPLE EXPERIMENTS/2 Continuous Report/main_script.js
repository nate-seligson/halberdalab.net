/* eslint-disable no-unused-vars */
/* eslint-disable no-undef */
//****************************//
//Color continuous report experiment- FOR SAMPLE USE ONLY
//Designed by Caroline MYERS, Chaz FIRESTONE, and Justin HALBERDA (Johns Hopkins)
//Written by Caroline MYERS (Johns Hopkins)- [08/29/21]
//Last updated by Caroline MYERS (Johns Hopkins)- [08/14/22]

//////////////////*************************VARIABLES AND CONSTANTS********************//////////////////
const pilotMode = 1; // 1 for pilot mode on, 0 for pilot mode off
const saveDataToServer = 0;
const saveDataLocally = 1;
const c = document.getElementById('myCanvas');
const ctx = c.getContext('2d');
var timeline = [];
let canvasSizeX = c.width;
let canvasSizeY = c.height;
let stimulusSizeX = 100;
let stimulusSizeY = 100;
let canvasMidpointX = canvasSizeX / 2; let canvasMidpointY = canvasSizeY / 2;  
const numTrialsBreak = 20; // number of trials we give subject before offering a break
const numReps = 1;//90;//30; // we have 4 sessions of 30 reps each. //50;//20;//18;//35; //30 //35 //2
var numMasks = 100; 
var fullScreen = 1; 
const setSizeMax = 36;
const item_size = 90;//45; // for precision this is defined within the plugin as 180
const mask_size =  item_size * 2; // no mask for precision
const outerRad = 300;

//////////////////*************************GET PROLIFIC INFO********************//////////////////
const PROLIFICLINK = 'https://app.prolific.co/submissions/complete?cc=1FE217EC';


 

// capture info from Prolific
var subject_id = jsPsych.data.getURLVariable('PROLIFIC_PID');
var study_id = jsPsych.data.getURLVariable('STUDY_ID');
var session_id = jsPsych.data.getURLVariable('SESSION_ID');

if (typeof subject_id == 'undefined') {
    subject_id = Date.now();
}

if (typeof study_id == 'undefined') {
    study_id = 'Color_2.1.2';
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
const possibleRadii2 = [outerRad, outerRad - mask_size, outerRad - (mask_size*2)];

const allMasks = [];
for(let ii = 1; ii <= numMasks; ii++) {
    allMasks.push(['img/mask' + ii.toString() + '.png']);
}

const otherPreloadImages =  [['img/trainingExtraEasy.png'],
    ['img/TaskInstructions2.png'],['img/TaskInstructions1.png'],['img/trainingMedium.png'],['img/trainingEasy.png'],
    ['img/trainingHard.png'],['img/endTraining.png']];


const trialTypes = ['ori-precision2','ori-report'];
const instructionImgs = ['img/training1.png','img/training2.png','img/training3.png','img/training4.png','img/training5.png','img/training6.png'];

const allImgs = allMasks.concat(otherPreloadImages);

var preload = {
    type: 'preload',
    images: allImgs,
    show_detailed_errors: true
    
};
timeline.push(preload);
var possibleMaskRotations = range(0, 359);
var possibleRotations = range(0, 359);
var possibleLocations = range(0,23);
var possibleColors = range(0, 359);

var factors = { 
    dispTime: [16,66,132,300], 
    setSize: [1,3,5],
};

var training_factors = { 
    dispTime: [1000, 800, 500, 132, 16],

};
const dispTimesTraining = [1000, 800, 500, 132, 16]; //[600, 300, 300, 150, 16];
const setSizesTraining = [1,3,5,5,5];
const mask_display_timesTraining = [1000, 800, 500, 132, 132];
var full_design = jsPsych.randomization.factorial(factors, numReps); //2
var training_design = jsPsych.randomization.factorial(training_factors, 1);
var totalNumTrials = full_design.length + 1;


//FIRST TRAINING
for(let kk = 0; kk < 5; kk++) {
    training_design[kk].dispTime = dispTimesTraining[kk];
    training_design[kk].setSize = setSizesTraining[kk];
    training_design[kk].positions = jsPsych.randomization.sampleWithoutReplacement(possibleLocations, training_design[kk].setSize);
    training_design[kk].colors = createArray(0, 359, setSizesTraining[kk], 10, jsPsych.randomization.sampleWithoutReplacement(possibleColors, 1)[0]); 
    training_design[kk].mask = [jsPsych.randomization.sampleWithReplacement(allMasks, training_design[kk].setSize)];
    training_design[kk].maskdispTime = mask_display_timesTraining[kk];
    training_design[kk].maskRotation = jsPsych.randomization.sampleWithoutReplacement(possibleMaskRotations, training_design[kk].setSize);
    training_design[kk].instructionImg = instructionImgs[kk];
    training_design[kk].item_size = item_size,
    training_design[kk].respWheelRot = jsPsych.randomization.sampleWithoutReplacement(possibleRotations, 1)[0];
    training_design[kk].instructionImg = instructionImgs[kk];
    training_design[kk].dispTime = dispTimesTraining[kk];

}


for(let ll = 0; ll < full_design.length; ll++) {
    full_design[ll].positions = jsPsych.randomization.sampleWithoutReplacement(possibleLocations, 36);
    full_design[ll].respWheelRot = jsPsych.randomization.sampleWithoutReplacement(possibleRotations, 1)[0];
    full_design[ll].mask = [jsPsych.randomization.sampleWithReplacement(allMasks, 36)];
    full_design[ll].maskRotation = jsPsych.randomization.sampleWithoutReplacement(possibleMaskRotations, 36);
 
    // this is the one 

    full_design[ll].colors = jsPsych.randomization.sampleWithReplacement(possibleColors, 1);  
    full_design[ll].colors = createArray(0, 359, full_design[ll].setSize, 10, full_design[ll].colors[0]); 
   
    //full_design[ll].setSize = 36;
    full_design[ll].item_size = item_size;
    full_design[ll].mask_display_time = 132;      
}
/////LABEL TRAINING TRIAL TYPES

// training_design[0].MYTRIALTYPE2 ='color-precision2';
// training_design[1].MYTRIALTYPE2 = 'color-report';
// training_design[2].MYTRIALTYPE2 = ['color-report'];
// training_design[3].MYTRIALTYPE2 = ['color-report'];
// training_design[4].MYTRIALTYPE2 = ['color-report'];

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
if (fullScreen == 1) {
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

/////////////////////*************SAVE DESIGN IF WE WANT ********************//////////////////

console.log(full_design);
function download(data, filename, type) {
    var file = new Blob([data], {type: type});
    if (window.navigator.msSaveOrOpenBlob) // IE10+
        window.navigator.msSaveOrOpenBlob(file, filename);
    else { // Others
        var a = document.createElement('a'),
            url = URL.createObjectURL(file);
        a.href = url;
        a.download = filename;
        document.body.appendChild(a);
        a.click();
        setTimeout(function() {
            document.body.removeChild(a);
            window.URL.revokeObjectURL(url);  
        }, 0); 
    }
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
//FAMILIARIZATION T1: INSTRUCTIONS
var trainingInstructions = {
    type: 'image-keyboard-response',
    stimulus: jsPsych.timelineVariable('instructionImg'),
    post_trial_gap: 50
};
//FAMILIARIZATION T2: TASK
var trainingTrial = {
    timeline: [{
        type: 'color-report2',
        set_size: jsPsych.timelineVariable('setSize'),
        //radius2: jsPsych.timelineVariable('radius2'),
        item_colors: jsPsych.timelineVariable('colors'),
        which_test: 0,
        min_difference: 10,//20,
        mask_display_time: jsPsych.timelineVariable('maskdispTime'),
        display_time: jsPsych.timelineVariable('dispTime'),
        item_positions: jsPsych.timelineVariable('positions'),
        spinAmt: jsPsych.timelineVariable('respWheelRot'),
        delay_time: 0, //Time before probe appears'
        delay_start: 1000, // 1000 Delay before starting trial
        color_wheel_spin: true,
        click_to_start: true,
        maskArray: jsPsych.timelineVariable('mask'),
        feedback: false,
        //num_placeholders: setSizeMax,
        //item_size: item_size,
        //mask_size: mask_size,
        possibleRadii2: possibleRadii2,
    
        on_finish: function (data) {
            data.interaction_data = jsPsych.data.getInteractionData().values();
            data.CMDispTime = jsPsych.timelineVariable('dispTime');
            data.maskArray = jsPsych.timelineVariable('mask'),
            data.maskRotation = jsPsych.timelineVariable('maskRotation'),
            data.respWheelRot = jsPsych.timelineVariable('respWheelRot'),
            data.item_positions = jsPsych.timelineVariable('positions'),
            data.task = 'training',
            data.CM_colors = jsPsych.timelineVariable('colors');
            data.trialType = 'training';
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
            main_T1_Fix.stimulus =  `Wow! You've completed ${trial_count} out of ${totalNumTrials} trials! </p> <p>  </p><p> Take a quick break, then press any key when you're ready to continue.`;
        }
        else if (trial_count % numTrialsBreak !== 0) {  
            main_T1_Fix.trial_duration = 500,
            main_T1_Fix.choices = jsPsych.NO_KEYS,
            main_T1_Fix.stimulus = '';   
        }
    }
};
//////////////////*************************MAIN T2: STIMULI********************//////////////////
var main_T2_Trial = {
    timeline: [{
        type: 'color-report2',
        mask_display_time: jsPsych.timelineVariable('mask_display_time'),
        item_colors: jsPsych.timelineVariable('colors'),
        set_size: jsPsych.timelineVariable('setSize'),
        display_time: jsPsych.timelineVariable('dispTime'),
        which_test: 0,
        // radius2: jsPsych.timelineVariable('radius2'),
        min_difference: 10,//20,
        click_to_start: true,
        item_positions: jsPsych.timelineVariable('positions'),
        spinAmt: jsPsych.timelineVariable('respWheelRot'),
        delay_time: 0, //Time before probe appears'
        //delay_start: 1000, // 1000 Delay before starting trial
        color_wheel_spin: true,
        num_placeholders: setSizeMax,
        maskArray: jsPsych.timelineVariable('mask'),
        feedback: false,
        // item_size: item_size,
        //mask_size: mask_size,
        possibleRadii2: possibleRadii2,
        on_finish: function (data) {
            data.CMDispTime = jsPsych.timelineVariable('dispTime');
            data.starting_value = jsPsych.timelineVariable('respWheelRot');
            data.maskArray = jsPsych.timelineVariable('mask');
            data.item_positions = jsPsych.timelineVariable('positions'),
            data.task = 'main',
            data.CM_colors = jsPsych.timelineVariable('colors'),
            data.trialType = 'main';
        }
    }]
};

var shuffledArray = jsPsych.randomization.shuffle([main_T1_Fix,main_T2_Trial]);

//////////////////************NOW PUT IT ALL TOGETHER AND WHAT DO YOU GET?! (an experiment)***********//////////////////

var mainExperiment = {
    timeline: shuffledArray,
    timeline_variables: full_design,
    repetitions: 0,
    randomize_order: true
};
timeline.push(mainExperiment);




function convertJsonToCsv(json) {
    const keys = Object.keys(json[0]);
    const csvRows = [];
  
    // headers
    csvRows.push(keys.join(','));
  
    // data
    for (const row of json) {
        csvRows.push(keys.map(key => row[key]).join(','));
    }
  
    return csvRows.join('\n');
}

let csvStr = convertJsonToCsv(full_design);

download(csvStr, 'full_design.csv', 'text/csv');


//////////////////*************************SAVE DATA FXN********************//////////////////
function saveData(name, data){
    var xhr = new XMLHttpRequest();
    xhr.open('POST', 'write_data.php'); // 'write_data.php' is the path to the php file described above.
    xhr.setRequestHeader('Content-Type', 'application/json');
    xhr.send(JSON.stringify({filename: name, filedata: data}));
}
//////////////////*************************INIT AND SAVE EXPERIMENT DATA********************//////////////////
/* var endQuestion = {
    type: 'survey-text',
    questions: [
        {prompt: 'Thank you! You are almost done! Is there anything we should know about your participation in this experiment today?'}
    ],
};
timeline.push(endQuestion);



 */



//////////////////*************************INIT AND SAVE EXPERIMENT DATA********************//////////////////

var endQuestion1 = {
    type: 'survey-text',
    preamble: 'Thank you! You\'re almost done! We just have a few questions.',
    questions: [
        {prompt: 'Did you notice anything particular or strange about the experiment? If so, please explain:', rows: 4}
    ],
    on_finish: function (data) {
        data.task = 'post-test';
        data.trialType = 'post-test-1.0';
    }
};
//timeline.push(endQuestion1); //UNCOMMENT LATER

var endQuestion2 = {
    type: 'survey-text',
    preamble: 'Thank you! You\'re almost done! We just have a few questions.',
    questions: [
        {prompt: 'On some trials you probably felt like you did not know the answer and had to guess. Please estimate what <strong> percentage </strong> of trials you guessed on during the task.', placeholder: '%',rows: 1},
        {prompt: 'What did you do when that happened? In other words, how did you make your guesses when you were very unsure?', rows: 4}
    ],
    on_finish: function (data) {
        data.task = 'post-test';
        data.trialType = 'post-test-2.0';
    }
};

//'
//timeline.push(endQuestion2); //UNCOMMENT LATER

/* var endQuestion3 = {
    type: 'survey-text',
    preamble: `Thank you! You're almost done! We just have a few questions. (3/3)`,
    questions: [
        {prompt: '3. Did you notice anything particular or strange about the experiment? If so, please explain:', rows: 4}
    ],
};

timeline.push(endQuestion3); */


var endQuestion3_Intro = {
    type: 'html-button-response',
    stimulus: '<p style="font-size: 24px; ">When making guesses, people might guess some colors more than others. Which colors do you think people are most likely to guess?  </p> <p>  </p><p> </p> We are now going to show you the color wheel you used during the experiment. </p> <p>  </p><p> </p> Use the mouse to select 3 regions on the color wheel that you think people would be more likely to select when guessing. </p> <p>  </p><p> </p> It is fine to select nearby regions if needed.  </p>',
    choices: ['Continue'],
    prompt: '<p> </p>'
};

//timeline.push(endQuestion3_Intro); //UNCOMMENT LATER

var endQuestion3_1 = {
    type: 'color-report-last-question',
    set_size: 1,
    which_test: 0,
    min_difference: 20,
    click_to_start: false,
    display_time: 0,
    delay_time: 0, //Time before probe appears'
    delay_start: 500, // 1000 Delay before starting trial
    mask_display_time: 0, //132
    color_wheel_spin: true,
    feedback: false,
    responses_per_item: 3,
    on_finish: function (data) {
        data.task = 'post-test',
        data.trialType = 'post-test-3.1';
    }
};
//timeline.push(endQuestion3_1); //UNCOMMENT LATER



var endQuestion4_Intro = {
    type: 'html-button-response',
    stimulus: '<p style="font-size: 24px; ">This time, consider only your own experience, which may be the same or different from how others guess.  </p> <p>  </p><p> </p> Did you notice any patterns in the colors you chose when you were guessing? </p> <p>  </p><p> </p> Use the mouse to select 3 regions on the color wheel that you think you were more likely to select when guessing. </p> <p>  </p><p> </p> It is okay to select the same region, and it is okay if your answers are similar to the previous question. </p> <p>  </p><p> </p> <br> <br> <br>  </p>',
    choices: ['Continue'],
    prompt: '<p> </p>'
};
//timeline.push(endQuestion4_Intro); //UNCOMMENT LATER


var endQuestion4_1 = {
    type: 'color-report-last-question',
    set_size: 1,
    which_test: 0,
    min_difference: 20,
    click_to_start: false,
    display_time: 0,
    delay_time: 0, //Time before probe appears'
    delay_start: 500, // 1000 Delay before starting trial
    mask_display_time: 0, //132
    color_wheel_spin: false,
    feedback: false,
    responses_per_item: 3,

    on_finish: function (data) {
        data.task = 'post-test',
        data.trialType = 'post-test-4.1';
    }
};
//timeline.push(endQuestion4_1); //UNCOMMENT LATER


var endQuestion5 = {
    type: 'survey-text',
    preamble: `You probably noticed that on some trials, the dots were on the screen for a little longer time, while on other trials, the masks seemed to come on right away. <br>
    In fact, the trials you saw were choisen from a range of display times. <br>
    In the list below, please enter a percentage that estimates how often you saw trials of each duration. <br>
    <strong> Be careful! Depending on the version of the experiment you participated in, the correct answer for some of these categories may be 0%. 
    `,
    questions: [
        {prompt: '<strong>   1 sec', placeholder: '%',rows: 1},
        {prompt: '<strong>  .5 sec', placeholder: '%',rows: 1},
        {prompt: '<strong> .25 sec', placeholder: '%',rows: 1},
        {prompt: '<strong>  .1 sec', placeholder: '%',rows: 1},
        {prompt: '<strong> .01 sec', placeholder: '%',rows: 1},
        {prompt: '<strong>   0 sec', placeholder: '%',rows: 1},
    ],
    on_finish: function (data) {
        data.task = 'post-test';
        data.trialType = 'post-test-5.0';
    }
};
//timeline.push(endQuestion5); 


var endQuestion6 = {
    type: 'survey-html-form',
    preamble: '<p> You probably noticed that on some trials, the dots were on the screen for a little longer time, while on other trials, the masks seemed to come on right away. In fact, the trials you saw were choisen from a range of display times. <br> In the list below, please enter a percentage that estimates how often you saw trials of each duration. <br> <b> Be careful! Depending on the version of the experiment you participated in, the correct answer for some of these categories may be 0%. </b> </p>',


    html: '<p> <b> 1 sec:   <input name="first" type="text" size="10"/> % <br> <b>  .5 sec:  <input name="second" type="text"  size="10" />% <br> <b> .25 sec: <input name="third" type="text" size="10" />% <br> <b> .1 sec:  <input name="fourth" type="text" size="10"/>% <br>  <b> .01 sec: <input name="fifth" type="text" size="10"/>% <br> <b>  0 sec: <input name="sixth" type="text" size="10" />% <br>  </p>'
};
//timeline.push(endQuestion6); //UNCOMMENT LATER







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

if (saveDataLocally == 1) {
    jsPsych.init({
        timeline: timeline,
        randomize_order: true,
        override_safe_mode: true,
        on_finish: function () {
            jsPsych.data.getInteractionData().values();
            jsPsych.data.displayData('csv');
            jsPsych.data.get().localSave('csv','mydata.csv');
        }
    });
}



function createArray(minimum, maximum, setSize, minDistance, firstValue) {
    if ((setSize - 1) * minDistance > (maximum - minimum)) {
        throw new Error('Impossible to generate such a set with provided parameters.');
    }

    if (firstValue < minimum || firstValue > maximum) {
        throw new Error('First value must be within the specified range.');
    }

    // Create an equally spaced array with firstValue as the starting point
    const step = (maximum - minimum) / setSize;
    let array = Array.from({length: setSize}, (_, i) => firstValue + i * step);

    // Handle wrapping for values exceeding the maximum
    array = array.map(value => {
        if (value > maximum) {
            value -= (maximum - minimum + 1);
        }
        return Math.round(value);
    });

    // Handle potential minDistance violation due to rounding
    array.sort((a, b) => a - b);
    for (let i = 0; i < setSize - 1; i++) {
        if (array[i + 1] - array[i] < minDistance) {
            array[i + 1] = array[i] + minDistance;
            if (array[i + 1] > maximum) {
                array[i + 1] -= (maximum - minimum + 1);
            }
        }
    }

    // Handle wrapping issue for the last and first element
    if (array[0] + (maximum - minimum + 1) - array[array.length - 1] < minDistance) {
        array[0] = array[array.length - 1] + minDistance;
        if (array[0] > maximum) {
            array[0] -= (maximum - minimum + 1);
        }
    }

    // Ensure the specified firstValue is the first element of the array
    while (array[0] !== firstValue) {
        array.push(array.shift());
    }

    // Shuffle the array while keeping the firstValue in place
    for (let i = array.length - 1; i > 1; i--) {
        let j = Math.floor(Math.random() * (i - 1)) + 1;
        [array[i], array[j]] = [array[j], array[i]];
    }
    console.log(array);
    return array;
    
}
