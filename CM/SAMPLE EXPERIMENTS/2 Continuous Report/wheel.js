var wheel_radius = 100; // in function
var wheelOptions = []; // in function
var wrap = (v)=>v; // global
var trial = {
    color_wheel_list_options: []
}
var item_colors = {} // global

var getColor = (c)=>c // global

var wheel_spin = 1 // in function

var center= 1 // global

function displayWheel(){
              
    var html = `<div id='backgroundRing' 
    style='border: border-radius: 50%;
           position: absolute;
           top: 17.5px;
           left: 17.5px;
           width: ${wheel_radius*2}px;
           height: ${wheel_radius*2}px'>&nbsp;
  </div>`;

  wheelOptions = new Array();
  if (trial.color_wheel_list_options.length>0) {
      for (var i=0; i<trial.color_wheel_list_options.length; i++) {
          wheelOptions.push(
              wrap(
                  trial.color_wheel_list_options[i] + item_colors[trial.which_test]
                )
            );
      }
  } else {
      var stepSize = 360 / trial.color_wheel_num_options;
      var st = (trial.which_test==-1) ? 0 : item_colors[trial.which_test];
      for (var i=st; 
          i>=st-360; 
          i-=stepSize) {
          wheelOptions.push(i);
      }
  }


  for (var i=0; i<wheelOptions.length; i++) {
    var deg = wrap(wheelOptions[i]);
    var col = getColor(deg);
    var positionDeg = wrap(deg + wheel_spin);
    var topPx = center-10 + wheel_radius * Math.sin(positionDeg/180.0*Math.PI);
    var leftPx = center-10 + wheel_radius * Math.cos(positionDeg/180.0*Math.PI);    
    html += `<div class='contMemoryChoice' colorClicked='${deg}' 
         id='colorRing${deg}' style='position:absolute;
     background-color: rgb(${Math.round(col[0])}, ${Math.round(col[1])}, 
     ${Math.round(col[2])}); top: ${topPx}px; left: ${leftPx}px;'></div>`;
  }

  document.getElementById('reportDiv').innerHTML = html;

}