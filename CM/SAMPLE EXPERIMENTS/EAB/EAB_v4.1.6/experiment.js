/* eslint-disable no-unused-vars */
/* eslint-disable no-mixed-spaces-and-tabs */
/* eslint-disable no-undef */


////setting some stuff up so we can randomize between participants? 
// list of possible condition assignments for subjects


/// the rest

const pilotMode = 0;
var rsvp_task = []; // main timeline
const numStimPerTrial = 17;
//const numStimPerTrial = 24;
const numFires = 56; // how many fire stimuli we have 
const numnonCriticalDistractors = 256; //right now we have 256 outdoor scenes 



if (pilotMode == 1) {
    minTrainingAcc = 0;
} else {
    minTrainingAcc = 75;
}
const numtargetImages = 192; // 56 fire targets, 56 neutral targets
const numTrialsBreak = 20; 
const PROLIFICLINK = 'https://app.prolific.co/submissions/complete?cc=75852D8F';



///////////DEFINE OUR NON TARGETS
const nonCriticalDistractors = [];
for(let ii = 1; ii <= numnonCriticalDistractors; ii++) {
    nonCriticalDistractors.push('img/nontarget_distractor' + ii.toString() + '.jpeg');
}

///////////DEFINE OUR NON TARGETS
const targetImages = [];
for(let ii = 1; ii <= numtargetImages; ii++) {
    targetImages.push('img/t2_targets' + ii.toString() + '.jpeg');
}

///////////DEFINE OUR T1 TARGETS/CRITICAL DISTRACTORS (FIRES)
const fireTargets = [];
for(let ii = 1; ii <= numFires; ii++) {
    fireTargets.push('img/fire' + ii.toString() + '.jpeg');
}

// response choices
var response_choices = ['1', '0'];

// stimuli definitions
var rsvp_iti = {
    type: 'html-keyboard-response',
    stimulus: '<span></span>',
    choices: jsPsych.NO_KEYS,
    trial_duration: 0, //30
    data: {test_part: 'iti'},
   
};
var rsvp_demo_iti = {
    type: 'html-keyboard-response',
    stimulus: '<span></span>',
    choices: jsPsych.NO_KEYS,
    trial_duration: 90,
    data: {test_part: 'iti'},
    
};
var fixation = {
    type: 'html-keyboard-response',
    stimulus: '<div class="rsvp">+</div>',
    choices: jsPsych.NO_KEYS,
    trial_duration: 2000,
    data: {test_part: 'fixation'},
   
};
var blank = {
    type: 'html-keyboard-response',
    stimulus: '<div class="rsvp" ></div>',
    choices: jsPsych.NO_KEYS,
    trial_duration: 250,
    data: {test_part: 'blank'},
    
};
var rsvp_stimulus_block = {
    type: 'html-keyboard-response',
    stimulus: jsPsych.timelineVariable('stimulus'),
    choices: jsPsych.NO_KEYS,
    trial_duration: 100,
    //  trial_duration: 500,
    data: jsPsych.timelineVariable('data'),
};

var critical_trial_block = {
    type: 'html-keyboard-response',
    stimulus: jsPsych.timelineVariable('stimulus'),
    choices: jsPsych.NO_KEYS,
    trial_duration: 100,
    //  trial_duration: 500,
    data: jsPsych.timelineVariable('data'),
};

var rsvp_demo_stimulus_block = {
    type: 'html-keyboard-response',
    stimulus: jsPsych.timelineVariable('stimulus'),
    choices: jsPsych.NO_KEYS,
    trial_duration: 210,
  //  data: jsPsych.timelineVariable('data'),

    
};

var practice_rsvp_stimulus_block = {
    type: 'html-keyboard-response',
    stimulus: jsPsych.timelineVariable('stimulus'),
    choices: jsPsych.NO_KEYS,
    trial_duration: 210,
  //  data: jsPsych.timelineVariable('data'),

   
};


var response_block = {
    type: 'html-keyboard-response',
    stimulus: jsPsych.timelineVariable('stimulus'),
    prompt: jsPsych.timelineVariable('prompt'),
    choices: response_choices,
    data: jsPsych.timelineVariable('data'),
    // trial_duration: 5000,
    on_finish: function(data) {
        data.correct = data.correct_responses == data.key_press; 
        // data.correct = data.correct_responses.includes(data.key_press); // accuracy irrespective of order
        if ( ! data.lag ) {                                             // only T2 has a lag
	    data.t1_correct = data.correct_response == data.key_press;  // T1 accuracy
            data.t2_correct = data.correct_response == data.key_press;
        } else {
            data.t1_correct = data.correct_response == data.key_press; 
	    data.t2_correct = data.correct_response == data.key_press;  // T2 accuracy
        }
    },

  

};



/***********************************************************************************************
                                    1. GET PROLIFIC INFO
/***********************************************************************************************/


// capture info from Prolific
var subject_id = jsPsych.data.getURLVariable('PROLIFIC_PID');
var study_id = jsPsych.data.getURLVariable('STUDY_ID');
var session_id = jsPsych.data.getURLVariable('SESSION_ID');
var subjectID = subject_id;

if (typeof subject_id == 'undefined') {
    subject_id = Date.now();}

if (typeof study_id == 'undefined') {
    study_id = 'EAB v4.1.6';}

if (typeof session_id == 'undefined') {
    session_id = 'today';}

if (typeof subject_id !== 'string') {
    subject_id = subject_id.toString();}

jsPsych.data.addProperties({
    subject_id: subject_id,
    subjectID: subjectID,
    study_id: study_id,
    session_id: session_id,});

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
                                  8. HELLO AND WELCOME
/***********************************************************************************************/
var intro_T1_Welcome = {
    type: 'fullscreen', 
    message: `What a beautiful ${todayDate} to do some awesome science! </p> <p>  </p><p> </p>
    By completing this survey or questionnaire, you are consenting to be in this research study. </p>
    Your participation is voluntary and you can stop at any time.
    <p> [Press any key to begin in full screen mode.] </p>
    
    `,
    fullscreen_mode: true
};
rsvp_task.push(intro_T1_Welcome);

// get a big list of all of our images
var allImgsA = fireTargets.concat(nonCriticalDistractors);
const allImgs = allImgsA.concat(targetImages);

var preload = {
    type: 'preload',
    images: allImgs,
	 
	 show_detailed_errors: true,
	 auto_preload: true,
    message: 'Please hold on- the experiment is loading. This may take a few minutes.',
    // max_load_time: 300000, // 2 minute,
	 error_message: 'The experiment failed to load. Please contact the researcher.',
     on_start: function() {
      
            jsPsych.setProgressBar(0);
    
}
};
rsvp_task.push(preload);


// instructions
var instructions_1 = {
    type: 'html-keyboard-response',
    stimulus: '<div class=\'instructions\'><p>You will see a series of scene images rapidly ' +
            'appearing on the computer screen. One of the scene images will be ROTATED, either to the left or to the right.</p><p>When the series ends, you have to ' +
            'respond to the question ‘Which way was the scene rotated?’</p><p>If the scene was rotated left, ' +
            'you will press the 1 key. If the scene was rotated right, press the 0 key. ' +
            '</p>' +
            '<p>Press any key to see an example of the task.</p></div>',
    data: {test_part: 'instructions'},
    post_trial_gap: 1000,
    on_start: function() {
      
        jsPsych.setProgressBar(0);

}
};
rsvp_task.push(instructions_1);

// make slow instruction trial
rsvp_task.push(make_rsvp_timeline([ {t1_location: 2, lag: 8, t1_type: 'neutral', rotate: '1',phase: 'practice'} ], 'instructions'));

var instructions_2 = {
    type: 'html-keyboard-response',
    stimulus: '<div class=\'instructions\'><p>In the example you just saw, ' +
            'the images appeared quite slowly.</p>' +
            '<p>The real task is more challenging, as the images ' +
            'will appear much more rapidly. This will feel much harder! </p>' +
            ' First, you will complete a practice block. </p>' +
            '<p> <strong>You need to respond correctly on at least 75% of the practice trials to advance, so pay close attention! </strong> </p>' +
            '<p>Press any key to start the practice.</p></div>',
    data: {test_part: 'instructions_2'},
    post_trial_gap: 1000,
    on_start: function() {
      
        jsPsych.setProgressBar(0);

}
};
rsvp_task.push(instructions_2);


// Factorial design
// 3 locations x 4 lags = 12

// 3 T1 locations X 8 lags X 2 t1 types X 2 rotations = 96
var factors = {
    t1_location: [4,6,8],
    lag: [1,2,3,4,5,6,7,8], //[1,2,3,4,5,6,7,8],
    t1_type: ['neutral','fire'],
    rotate: ['1', '0'],

};

// 2 * 1 * 8 = 16 practice

if (pilotMode == 0) {
    var factorsPractice = {
        t1_location: [8], //randomize later
        lag: [1, 2, 3, 4, 5, 6, 7, 8],// [1, 2, 5, 8],
        t1_type: ['neutral'],
        rotate: ['0', '1'],

    };
} 


if (pilotMode == 1) {
    var factorsPractice = {
        t1_location: [8], //randomize later
        lag: [1],// [1, 2, 5, 8],
        t1_type: ['neutral'],
        rotate: ['0', '1'],

    };
} 

var practice_repetitions = 1; //2
var test_repetitions     = 1;//2;
var practice_block       = 0;

totalNumTrials = 97 * test_repetitions; //96

var performance_block = {
    type: 'html-keyboard-response',
    stimulus: function() {
        var practice_trials = practice_repetitions * 16; // THIS NUMBER IS TOTAL NUMBER OF PRACTICE TRIALS, MAKE SURE TO CHANGE
  	//var practice_trials = practice_repetitions * 12;
  	var correct         = 0;
  	for (i = 1; i <= practice_trials; i++) {
  		var trials         = jsPsych.data.get().filter({phase: 'practice' + practice_block});
	    trials             = trials.filter({trial_number: i});
            var correct_trials = trials.filter({correct: true});
            if (correct_trials.count() >= 1) correct++;
            //if (correct_trials.count() > 1) correct++;
  	}
        var accuracy = Math.round(correct / practice_trials * 100);

        //if (accuracy < 100) {
        if (accuracy >= minTrainingAcc) {
    	// practice accuracy achieved, so build test trials



    	var test_timeline = make_rsvp_timeline(jsPsych.randomization.factorial(factors, test_repetitions), 'test');
            jsPsych.addNodeToEndOfTimeline(test_timeline, function(){});

            var thanks = {	
		  type: 'html-keyboard-response',
		  stimulus: '<div class=\'instructions\'><p>Thank you for completing this task.</p><p>Press any key to continue.</p></div>',
		  trial_duration: 10000,
		  data: {test_part: 'end'}

            };
            jsPsych.addNodeToEndOfTimeline(thanks, function(){});
            jsPsych.setProgressBar(0);
            var feedback = '<div class=\'instructions\'><p>Well done!  You responded correctly on '+accuracy+'% of the trials.</p>' +
	    '<p>Press any key to start the test. </p>  <p> <strong> Please try to respond as soon as you are prompted. </strong> </p></div>';

    


       
        } else { 
    	// practice accuracy too low, so repeat practice
    	practice_block++;
    	var practice_timeline = make_rsvp_timeline(jsPsych.randomization.factorial(factorsPractice, practice_repetitions), 'practice' + practice_block);
   
        practice_timeline.timeline.push(performance_block);
    	jsPsych.addNodeToEndOfTimeline(practice_timeline, function(){});
	    var feedback = '<div class=\'instructions\'><p>You responded correctly on '+accuracy+'% of the trials.</p>' +
	    '<p>You need to score at least 75% correctly before starting the test.</p>' +
	    '<p>Press any key to repeat the practice.</p></div>';
        
        }
        return feedback;
    }
};

// make initial practice block
if (pilotMode == 0) {
// push practice    
    rsvp_task.push(make_rsvp_timeline(jsPsych.randomization.factorial(factorsPractice, practice_repetitions), 'practice' + practice_block));

    //push critical first trial
    //rsvp_task.push(make_rsvp_timeline([ {t1_location: 1, lag: 8, t1_type: 'fire', rotate: '1',phase: 'practice2'} ], 'instructions'));

    //push rest of trials
    rsvp_task.push(performance_block);
} else {


    //push rest of trials
    rsvp_task.push(performance_block);
}


///////??NEW
function rsvp_trial(o) {
    //var stimuli                    = jsPsych.randomization.sampleWithoutReplacement(nonCriticalDistractors, 20);
    //var targets                    = jsPsych.randomization.sampleWithoutReplacement(numbers, 2);

    // stimuli array is n of items + 1 (t2)
    var stimuli                    = jsPsych.randomization.sampleWithoutReplacement(nonCriticalDistractors, numStimPerTrial + 2);
    // var rotateOpts					= ['1','0'];
    //var rotateOpts					= [' class="rotateimgR"',' class="rotateimgL"'];
    // var rotate 		 				= jsPsych.randomization.sampleWithoutReplacement(rotateOpts, 1);


    if (o.rotate == '0'){ ///right

        var rotationString = [' class="rotateimgR"'];
        //return rotationString;
    }

    else if (o.rotate == '1') { //left
        var rotationString = [' class="rotateimgL"'];

        //return rotationString;
    } 

    // this last stim will be t2: 
    // var tX 						 	= stimuli[numStimPerTrial] + rotationString;
    var t2 = jsPsych.randomization.sampleWithoutReplacement(targetImages, 1)[0] + rotationString;


    if (o.t1_type == 'neutral') {
        var t1                          = stimuli[numStimPerTrial + 1]; // if neutral, make t1 the last neutral image you drew

    } else if (o.t1_type == 'fire') {
        var t1                          = jsPsych.randomization.sampleWithoutReplacement(fireTargets, 1)[0];
    
    }


    // now we cut stimuli back down to it's normal length
    stimuli.length 					= numStimPerTrial;
    var targets                    = [t1, t2]; //here we subtract 1 from T1 because indexing starts at 0
    // var targets                    = [jsPsych.randomization.sampleWithoutReplacement(fireTargets, 1)[0], t2];

    stimuli[o.t1_location- 1]         = targets[0]; //here we subtract 1 from T1 because indexing starts at 0
    stimuli[(o.t1_location - 1) + o.lag] = targets[1]; //here we subtract 1 from T1 because indexing starts at 0


    
    return({stimuli: stimuli, t1_type: t1,rotationAns: o.rotate, targets: targets.map(jsPsych.pluginAPI.convertKeyCharacterToKeyCode)});
}

// Make a block of RSVP stimuli and responses
function make_rsvp_timeline(trials, phase) {
    rsvp_timeline = [];
    trial_number  = 0;
    for (trial in trials) {
        trial_number++;
        rsvp_stimuli = rsvp_trial(trials[trial]);
        /*

	if (jsPsych.timelineVariable('targetFire') == 1) {
		stimuli[o.t1_location]         = 'img/fire1.png';
		stimuli[o.t1_location + o.lag] = 'img/fire1.png';
	}

	else if (jsPsych.timelineVariable('targetFire') == 0) {
		stimuli[o.t1_location]         = 'img/fire2.png';
		stimuli[o.t1_location + o.lag] = 'img/fire2.png';
	}
	
*/
        // RSVP: 18 nonCriticalDistractorsScenes, 2 number targets
        var rsvp_block_stimuli = [];
        for (stimulus in rsvp_stimuli.stimuli) {
            rsvp_block_stimuli.push(
	  			{
                    //stimulus: rsvp_stimuli.stimuli[stimulus],
                    // WORKS:
                    //<div style='float: center;'><img src=` + rsvp_stimuli.stimuli[stimulus] + ` class="rotateimg180" ></img>


                    stimulus: `
					<div style='width: 900px;'>
					<div style='float: center;'><img src=` + rsvp_stimuli.stimuli[stimulus] + `  ></img>
					</div>
					`,

	  				data: {
	  					phase: phase,
	  					test_part: 'rsvp1',
	  					stim: rsvp_stimuli.stimuli[stimulus],
	  					trial_number: trial_number
	  				}
	  			}
	  		);
        }


        // attach RSVP stimuli to a timeline
        if (phase == 'instructions') {
            // slow stimuli
            stimulus_trial = rsvp_demo_stimulus_block;
            iti_trial      = rsvp_demo_iti;

        } else if (phase == 'practice') {
            stimulus_trial = practice_rsvp_stimulus_block;
            iti_trial      = rsvp_iti;
            
            ///////this
        } else if (phase == 'CRITICAL_FIRST_TRIAL') {
            stimulus_trial = critical_trial_block;
            iti_trial      = rsvp_iti;

        } else {
            stimulus_trial = rsvp_stimulus_block;
            iti_trial      = rsvp_iti;
        }
        var test_procedure = {
            timeline: [stimulus_trial, iti_trial],
            timeline_variables: rsvp_block_stimuli
        };

        // 2 responses
	  	var rsvp_response_stimuli = [];
	  	// T1
	
		  /*
	  	rsvp_response_stimuli.push(
			{
				stimulus:'<div class="rsvp">Which targets did you see?</div>',
				prompt: '<p class="rsvp">(press a number key)</p>',
				data: {
					phase: phase,
					test_part: 'response',

					correct_responses: rsvp_stimuli.rotationAns,
					correct_response: rsvp_stimuli.rotationAns,

					//correct_responses: rsvp_stimuli.targets,
					//correct_response: rsvp_stimuli.targets[0],
					trial_number: trial_number
				}
			}
		);

		*/
		
	  	// T2
        rsvp_response_stimuli.push(
            {
                //'<div style="font-size:60px;"> </div>',
                stimulus:'<div class="rsvp"> Was the rotated image rotated left (1 key) or right (0 key)?</div>',
                // stimulus:'<div class="rsvp" style = "line-height:134%"> Was the rotated image rotated left (1 key) or right (0 key)?</div>',
                //  prompt: '<p class="rsvp">(press another number key)</p>',
                data: {
                    phase: phase,
                    test_part: 'response',
                    correct_responses: rsvp_stimuli.rotationAns,
                    correct_response: rsvp_stimuli.rotationAns,
                    //    t1_type: o.t1_type,
                    //    t2_type: o.t2_type,
                    //correct_responses: rsvp_stimuli.targets,
                    //correct_response: rsvp_stimuli.targets[1],
                    t1_type: trials[trial].t1_type,
                    t1_image: rsvp_stimuli.t1_type,
                    
                    t2_image: rsvp_stimuli.stimuli[trials[trial].t1_location + trials[trial].lag],

                    t1_location: trials[trial].t1_location,
                    lag: trials[trial].lag,
                    t2_location: trials[trial].t1_location + trials[trial].lag,
                    trial_number: trial_number
                }
            }
        );
        // attach responses to timeline
        var response_procedure = {
            timeline: [response_block],
            timeline_variables: rsvp_response_stimuli
        };

        var feedback = {
            type: 'html-keyboard-response',
            stimulus: function(){
                // The feedback stimulus is a dynamic parameter because we can't know in advance whether
                // the stimulus should be 'correct' or 'incorrect'.
                // Instead, this function will check the accuracy of the last response and use that information to set
                // the stimulus value on each trial.
                var last_trial_correct = jsPsych.data.get().last(1).values()[0].correct;
                var internalPhase = jsPsych.data.get().last(1).values()[0].phase;
                // if (internalPhase == 'practice') {
                if (internalPhase == 'practice0' & last_trial_correct){
                    //'<div style="font-size:60px;"> </div>',
                    return '<p style="font-size:60px; color:red" >Correct!</p>'; // the parameter value has to be returned from the function
                } else if (internalPhase == 'practice'){
                    return '<p>Wrong.</p>'; // the parameter value has to be returned from the function

                    //extra suprise trial counter
                } else if (trial_number == 5){
                    return '<p>Wrong.</p>'; // the parameter value has to be returned from the function

                } else {
                    return '<p> </p>';
                }
            //}
            }

            
        };

        var trial_count = 0;
        var feedback2 = {
            type: 'html-keyboard-response',
            stimulus: '<div style="font-size:60px;"> </div>',
            //   render_on_canvas: true,
            //    canvas_size: [canvasSizeX,canvasSizeY],
            data: {
                task: 'main_T1_ITI'
            },
        
            on_start: function(feedback2) {
                

  
                trial_count++;

                var last_trial_correct = jsPsych.data.get().last(1).values()[0].correct;
                var internalPhase = jsPsych.data.get().last(1).values()[0].phase;

                if (internalPhase == 'practice' + practice_block  | internalPhase == 'instructions') {
                
                    if (last_trial_correct){
                        feedback2.trial_duration = 1000,
                        feedback2.stimulus =  'Correct! </p> <p>  </p><p> ';
                        jsPsych.setProgressBar(0);
                
                    } else {
                        feedback2.trial_duration = 1000,
                        feedback2.stimulus =  'Wrong. </p> <p>  </p><p> ';
                        jsPsych.setProgressBar(0);
                    
                    }
                    // and here's where we add in our sparkle: 
                } else if (trial_count % numTrialsBreak == 0) {
                    feedback2.stimulus =  `Wow! You've completed ${trial_count} out of ${totalNumTrials} trials! </p> <p>  </p><p> Take a quick break, then press any key when you're ready to continue.`
                    //feedback2.stimulus =  'Take a break for as long as you need!. </p> <p>  </p><p> ';
                    feedback2.choices = jsPsych.ALL_KEYS;
                    
                 

                }else if (internalPhase == 'test') {
                    feedback2.trial_duration = 0,
                    feedback2.choices = jsPsych.NO_KEYS,
                    feedback2.stimulus = '';

                    var curr_progress_bar_value = jsPsych.getProgressBarCompleted();
                    jsPsych.setProgressBar(curr_progress_bar_value + (1/totalNumTrials));
              



                }else {
                    feedback2.trial_duration = 0,
                    feedback2.choices = jsPsych.NO_KEYS,
                    feedback2.stimulus = '';
                }

                
            }
        };

        rsvp_timeline.push(fixation);
        rsvp_timeline.push(blank);
        rsvp_timeline.push(test_procedure);
        rsvp_timeline.push(response_procedure);
        //  if (phase == 'practice') {
        rsvp_timeline.push(feedback2);
        // }
    }
    return { timeline: rsvp_timeline };
}

function saveData(name, data){
    var xhr = new XMLHttpRequest();
    xhr.open('POST', 'write_data.php'); // 'write_data.php' is the path to the php file described above.
    xhr.setRequestHeader('Content-Type', 'application/json');
    xhr.send(JSON.stringify({filename: name, filedata: data}));
}

