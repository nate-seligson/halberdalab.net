//****************************//
//FLSearch  2.1.7- preregistered
//Designed by Caroline MYERS, Chaz FIRESTONE, and Justin HALBERDA (Johns Hopkins)
//Written by Caroline MYERS (Johns Hopkins)- [08/29/21]
//Last updated by Caroline MYERS (Johns Hopkins)- [11/16/21]
//****************************//
/* eslint-disable no-unused-vars */
/* eslint-disable no-undef */
/***********************************************************************************************
                                    1. GET PROLIFIC INFO
/***********************************************************************************************/

const PROLIFICLINK = 'https://app.prolific.co/submissions/complete?cc=4A853100';

// capture info from Prolific
var subject_id = jsPsych.data.getURLVariable('PROLIFIC_PID');
var study_id = jsPsych.data.getURLVariable('STUDY_ID');
var session_id = jsPsych.data.getURLVariable('SESSION_ID');

if (typeof subject_id == 'undefined') {
    subject_id = Date.now();}

if (typeof study_id == 'undefined') {
    study_id = 'FlSearch2.1.7-PREREGISTERED';}

if (typeof session_id == 'undefined') {
    session_id = 'today';}

if (typeof subject_id !== 'string') {
    subject_id = subject_id.toString();}

jsPsych.data.addProperties({
    subject_id: subject_id,
    study_id: study_id,
    session_id: session_id,});

/***********************************************************************************************
                                2. VARIABLES AND CONSTANTS
/***********************************************************************************************/
const pilotMode = 0; // 1 for pilot mode on, 0 for pilot mode off!
const c = document.getElementById('myCanvas'); 
const ctx = c.getContext('2d');
const numTrialsBreak = 20; // number of trials we give subject before offering a break
var numReps = 8; // 6- the number of repetitions of our full factorial design we want.
let canvasSizeX = c.width;
let canvasSizeY = c.height;
let stimulusSizeX = 800;
let stimulusSizeY = 800;
let canvasMidpointX = canvasSizeX / 2; let canvasMidpointY = canvasSizeY / 2;  
var timeline = [];

var fireDownDistractors = ['img/Fire_Down_Distractor.gif','img/Fire_Down_Distractor.gif','img/Fire_Down_Distractor.gif',
    'img/Fire_Down_Distractor.gif','img/Fire_Down_Distractor.gif','img/Fire_Down_Distractor.gif','img/Fire_Down_Distractor.gif',
    'img/Fire_Down_Distractor.gif','img/Fire_Down_Distractor.gif','img/Fire_Down_Distractor.gif','img/Fire_Down_Distractor.gif',
    'img/Fire_Down_Distractor.gif'];

var fireUpDistractors = ['img/Fire_Up_Distractor.gif','img/Fire_Up_Distractor.gif','img/Fire_Up_Distractor.gif',
    'img/Fire_Up_Distractor.gif','img/Fire_Up_Distractor.gif','img/Fire_Up_Distractor.gif','img/Fire_Up_Distractor.gif',
    'img/Fire_Up_Distractor.gif','img/Fire_Up_Distractor.gif','img/Fire_Up_Distractor.gif','img/Fire_Up_Distractor.gif',
    'img/Fire_Up_Distractor.gif'];

/***********************************************************************************************
                                  3. PRELOAD OUR IMAGES 
/***********************************************************************************************/
var preload = {
    type: 'preload',
    images: [['img/fix.png'],['img/Fire_Up_Target.gif'],['img/Fire_Down_Target.gif'], 
        ['img/Fire_Down_Distractor.gif'],['img/Fire_Up_Distractor.gif'],
        ['img/feedbackWrong.png'],['img/feedbackRight.png']],
    video: [['video/TaskInstructions.mp4'],['video/endTraining.mp4']],
    show_detailed_errors: true
    
};
timeline.push(preload);

/***********************************************************************************************
                                  4. SET UP OUR TRIALMAT 
/***********************************************************************************************/
////////Define our full factorial design:
var factors = {
    setSize: [4,5,6,7,8],
    searchCondition: ['targetUp_distractorsDown','targetDown_distractorsUp'],
    targetPresent: [true,false],
};
var full_design = jsPsych.randomization.factorial(factors, numReps); // 6 repetitions 

///////DEFINE OUR COMBINATIONS OF TARGET AND DISTRACTORS: TARGET NORMAL (UP)
for(let ii = 0; ii < full_design.length; ii++) {

    if (full_design[ii].searchCondition == 'targetUp_distractorsDown') {
        full_design[ii].Distractor = jsPsych.randomization.repeat(fireDownDistractors, 1);
        full_design[ii].Target = 'img/Fire_Up_Target.gif';
    }
}
///////DEFINE OUR COMBINATIONS OF TARGET AND DISTRACTORS: TARGET NORMAL (DOWN)
for(let ii = 0; ii < full_design.length; ii++) {

    if (full_design[ii].searchCondition == 'targetDown_distractorsUp') {
        full_design[ii].Distractor = jsPsych.randomization.repeat(fireUpDistractors, 1);
        full_design[ii].Target = 'img/Fire_Down_Target.gif';

    }
}
var totalNumTrials = full_design.length;

/***********************************************************************************************
                                       5. GET DATE
/***********************************************************************************************/
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

/***********************************************************************************************
                                      6. ENTER FULL SCREEN
/***********************************************************************************************/
if (pilotMode == 0) {
    timeline.push({
        type: 'fullscreen',
        fullscreen_mode: true
    });
}

/***********************************************************************************************
                   7. OPTIONAL, GET VIEWING DISTANCE AND USE DEGREES OF VISUAL ANGLE
/***********************************************************************************************/
/* 
if (pilotMode == 0) {
    var virtualChinrest = {

        type: 'virtual-chinrest',
        blindspot_reps: 1,
        resize_units: 'deg',
        pixels_per_unit: 50,
        //viewing_distance_report: 'none'

        on_finish: function(data){
            const windowHeightDVA =  jsPsych.data.get().filter({trial_type: 'virtual-chinrest'}).values()[0]['win_height_deg'];
            const windowWidthDVA =  jsPsych.data.get().filter({trial_type: 'virtual-chinrest'}).values()[0]['win_width_deg'];
            const pix2mmFactor =  jsPsych.data.get().filter({trial_type: 'virtual-chinrest'}).values()[0]['px2mm'];
            const pix2degFactor =  jsPsych.data.get().filter({trial_type: 'virtual-chinrest'}).values()[0]['px2deg'];
            const scaleFactor =  jsPsych.data.get().filter({trial_type: 'virtual-chinrest'}).values()[0]['scale_factor'];

            // TO GET ALL VALUES: 
            //jsPsych.data.get().filter({trial_type: 'virtual-chinrest'}).values();

        }
    };
    timeline.push(virtualChinrest);
}
*/ 
/***********************************************************************************************
                                  8. HELLO AND WELCOME
/***********************************************************************************************/
var intro_T1_Welcome = {
    type: 'html-keyboard-response', 
    stimulus: `What a beautiful ${todayDate} to do some awesome science! </p> <p>  </p><p> </p>
    By completing this survey or questionnaire, you are consenting to be in this research study. </p>
    Your participation is voluntary and you can stop at any time.
    <p> [Press any key to continue.] </p>
    
    `
};
timeline.push(intro_T1_Welcome);

var intro_T2_Instructions = {
    type: 'video-keyboard-response',
    stimulus: ['video/TaskInstructions.mp4'],
    response_ends_trial: true,
    width: 900,
    height: 900,
    autoplay: true,
    trial_ends_after_video: false,
};

timeline.push(intro_T2_Instructions);
/***********************************************************************************************
                              9. FAMILIARIZATION PERIOD, 4 TRIALS
/***********************************************************************************************/
// We will present 4 training trials, with feedback. 

var training_T1_Instructions = {
    type: 'html-keyboard-response',
    stimulus: `
    <p>First, we're going to do a few practice trials to make sure you understand the task. You will recieve feedback on each trial. </p>
    <p>[Press any key to begin the familiarization phase.]</p>
    `,
    post_trial_gap: 50
};
timeline.push(training_T1_Instructions);

//////////////////************************* training trial 1 ********************//////////////////
var training_T1_TargetPresent = {
    timeline: [{
        type: 'visual-search-circle',
        target: 'img/Fire_Down_Target.gif',
        foil: fireUpDistractors,
        fixation_image: 'img/fix.png',
        target_present: true,
        set_size: 4,
        target_size: [200,200],
        circle_diameter: 600,
        target_present_key: 'd',
        target_absent_key: 's',
        render_on_canvas: false,
    }],

    data: {
        task: 'training',
        correct_response: 'd',

    },

    on_finish: function(data){
        if(jsPsych.pluginAPI.compareKeys(data.response, 'd')){ 
            data.correct = true;
        } else {
            data.correct = false; 
        }
    }
};

var feedback = {
    type: 'html-keyboard-response',
    stimulus: function(){
        var last_trial_correct = jsPsych.data.get().last(1).values()[0].correct;
        if(last_trial_correct){ 
            return ' <div style=\'float: center; \'><img src=\'img/feedbackRight.png\'></img> </div> ';

        } else {
            return ' <div style=\'float: center;\'><img src=\'img/feedbackWrong.png\'></img> </div> ';
        }
    }
};
  
//////////////////************************* training trial 2 ********************//////////////////
var training_T2_TargetAbsent = {
    timeline: [{
        type: 'visual-search-circle',
        target: 'img/Fire_Down_Target.gif',
        foil: fireUpDistractors,
        fixation_image: 'img/fix.png',
        target_present: false,
        set_size: 4,
        target_size: [200,200],
        circle_diameter: 600,
        target_present_key: 'd',
        target_absent_key: 's',
        render_on_canvas: false,
    }],

    data: {
        task: 'training',
        correct_response: 's',

    },

    on_finish: function(data){
        if(jsPsych.pluginAPI.compareKeys(data.response, 's')){ // Score the response as correct or incorrect.
            data.correct = true;
        } else {
            data.correct = false; 
        }
    }
};

//////////////////************************* training trial 3 ********************//////////////////
var training_T3_TargetAbsent = {
    timeline: [{
        type: 'visual-search-circle',
        target: 'img/Fire_Up_Target.gif',
        foil: fireDownDistractors,
        fixation_image: 'img/fix.png',
        target_present: false,
        set_size: 6,
        target_size: [200,200],
        circle_diameter: 600,
        target_present_key: 'd',
        target_absent_key: 's',
        render_on_canvas: false,
    }],

    data: {
        task: 'training',
        correct_response: 's',

    },

    on_finish: function(data){
        if(jsPsych.pluginAPI.compareKeys(data.response, 's')){ 
            data.correct = true;
        } else {
            data.correct = false; 
        }
    }
};

//////////////////************************* training trial 4 ********************//////////////////
var training_T4_TargetPresent = {
    timeline: [{
        type: 'visual-search-circle',
        target: 'img/Fire_Down_Target.gif',
        foil: fireUpDistractors,
        fixation_image: 'img/fix.png',
        target_present: true,
        set_size: 8,
        target_size: [200,200],
        circle_diameter: 600,
        target_present_key: 'd',
        target_absent_key: 's',
        render_on_canvas: false,
    }],

    data: {
        task: 'training',
        correct_response: 'd',
    },

    on_finish: function(data){
        if(jsPsych.pluginAPI.compareKeys(data.response, 'd')){ 
            data.correct = true;
        } else {
            data.correct = false; 
        }
    }
};

var endTraining = {
    type: 'video-keyboard-response',
    stimulus: ['video/endTraining.mp4'],
    response_ends_trial: true,
    width: 900,
    height: 900,
    trial_ends_after_video: false,
};

//Pushing our familiarization period to the timeline
timeline.push(training_T1_TargetPresent, feedback,training_T2_TargetAbsent,feedback,training_T3_TargetAbsent, 
    feedback,training_T4_TargetPresent,feedback,endTraining);

/***********************************************************************************************
          10. DEFINE OUR TRIALS FOR THE MAIN EXPERIMENT, MAIN T1 (ITI) AND MAIN T2 (TRIAL)
/***********************************************************************************************/
    
//////////////////************************* main_T1_ITI ********************//////////////////

var trial_count = 0; // setting our trial counter to 0
var main_T1_ITI = {
    type: 'html-keyboard-response',
    stimulus: '<div style="font-size:60px;"> </div>',
    render_on_canvas: true,
    canvas_size: [canvasSizeX,canvasSizeY],
    data: {
        task: 'main_T1_ITI'
    },

    on_start: function(main_T1_ITI) {
        trial_count++;
        if (trial_count % numTrialsBreak == 0) {
            main_T1_ITI.stimulus =  `Wow! You've completed ${trial_count} out of ${totalNumTrials} trials! </p> <p>  </p><p> Take a quick break, then press any key when you're ready to continue.`;
        }
        else if (trial_count % numTrialsBreak !== 0) {  
            main_T1_ITI.trial_duration = 0,
            main_T1_ITI.choices = jsPsych.NO_KEYS,
            main_T1_ITI.stimulus = '';
        }
    }
};

//////////////////************************* main_T2_Trial ********************//////////////////

var main_T2_Trial = {
    type: 'visual-search-circle',
    target: jsPsych.timelineVariable('Target'),//'img/Fire_Up_Target.gif',
    foil: jsPsych.timelineVariable('Distractor'),
    fixation_image: 'img/fix.png',
    target_present: jsPsych.timelineVariable('targetPresent'),
    set_size: jsPsych.timelineVariable('setSize'),
    target_size: [200,200],
    circle_diameter: 600,
    target_present_key: 'd',
    target_absent_key: 's',
    canvas_size: [canvasSizeX,canvasSizeY],
    render_on_canvas: false,

    on_finish: function (data) {
        data.task = 'main_T2_Trial';
        data.target = jsPsych.timelineVariable('Target');
        data.foilCM = jsPsych.timelineVariable('Distractor');
        data.setSizeCM = jsPsych.timelineVariable('setSize');
        data.searchCondition = jsPsych.timelineVariable('searchCondition');
        if (jsPsych.timelineVariable('targetPresent') == true) {
            data.correct_response = 'd';
        } else if (jsPsych.timelineVariable('targetPresent') == false) {
            data.correct_response = 's';
        }

    }
};
  
/***********************************************************************************************
                           11. DEFINE OUR MAIN TIMELINE FOR THE EXPERIMENT
/***********************************************************************************************/

// FIRST BLOCK
var experiment = {
    timeline: [main_T1_ITI, main_T2_Trial],
    timeline_variables: full_design,
    repetitions: 1,
    randomize_order: true
};

var mainTimeline = {
    timeline: [experiment],
    timeline_variables: [full_design],
    repetitions: 1,
    randomize_order: true
};

timeline.push(mainTimeline); // push this to the timeline

/***********************************************************************************************
                                12. PARTICIPANT FEEDBACK QUESTION
/***********************************************************************************************/
var endQuestion = {
    type: 'survey-text',
    questions: [
        {prompt: 'Thank you! You are almost done! Is there anything we should know about your participation in this experiment today?'}
    ],
};
timeline.push(endQuestion); // push this to the timeline

/***********************************************************************************************
                                13. INITIALIZE EXPERIMENT AND SAVE DATA
/***********************************************************************************************/
jsPsych.init({
    timeline: timeline,
    randomize_order: true,
    repetitions: 1,
    // save data to server
    on_finish: function(){ saveData(subject_id, jsPsych.data.get().csv()),
    document.body.innerHTML = `
        <p> 
        <div style='width: 700px;'>
        <div style='float: center;'><img src='img/yay.png'></img>
        </div>
        <center> Thank you for completing the experiment! </p>
        </p> Please wait. You will be automatically redirected back to Prolific in 10 seconds. </p>
        </p> <strong>Please do not click out of this page or close this tab. </strong> </p>
        <p>Thank you! </center>  </p>
        `;
    document.documentElement.style.textAlign = 'center';

    setTimeout(function () { location.href = PROLIFICLINK; }, 10000); // redirect to prolific after 10 seconds such that our data can back up to the server.
    } 
});