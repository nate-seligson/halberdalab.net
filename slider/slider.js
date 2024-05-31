//---------------------------------+
//  CARPE  S l i d e r        1.5  |
//  2007 - 01 - 15                 |
//  By Tom Hermansson Snickars     |
//  Copyright CARPE Design         |
//  http://carpe.ambiprospect.com/ |
//---------------------------------+

// Global vars. You don't need to make changes here to change your sliders.
// Changing the attributes in your (X)HTML file is enough.


var carpeDefaultSliderLength      = 100;
var carpeSliderDefaultOrientation = 'horizontal';
var carpeSliderClassName          = 'carpe_slider';
var carpeSliderDisplayClassName   = 'carpe_slider_display';


// Function to calculate the normal CDF by given X
function normalCDF(x, mean, std){   //HASTINGS.  MAX ERROR = .000001
	var temp = (x - mean) / std
	var T=1/(1+.2316419*Math.abs(temp));
	var D=.3989423*Math.exp(-temp*temp/2);
	var Prob=D*T*(.3193815+T*(-.3565638+T*(1.781478+T*(-1.821256+T*1.330274))));
	if (temp>0) {
		Prob=1-Prob;
	}
	return Prob
}

// Reserved Function
function compute(form) {
    Z=eval(form.argument.value)
    M=eval(form.mean.value)
    SD=eval(form.stdev.value)
    with (Math) {
		if (SD<0) {
			alert("The standard deviation must be nonnegative.")
		} else if (SD==0) {
		    if (Z<M){
		        Prob=0
		    } else {
			    Prob=1
			}
		} else {
			Prob=normalcdf((Z-M)/SD);
			Prob=round(100000*Prob)/100000;
		}
	}
    form.result.value = Prob;
}

// Calculates a point Z(x), the Probability Density Function, on any normal curve. 
// This is the height of the point ON the normal curve.
// For values on the Standard Normal Curve, call with Mean = 0, StdDev = 1.
function normalPDF(x, Mean, StdDev)
{
	var a = (x - Mean) / StdDev;
	return Math.exp(-(a * a) / (2 * StdDev * StdDev)) / (Math.sqrt(2 * Math.PI) * StdDev); 
	//return Math.exp(-1 * a * a / 2) * .3989422804014327028632;
	//return -1 * Math.log(StdDev) - .9189385332046726695410 - a * a / 2;
}


// Function to show the diagram while changing slider
function showTest(slider) {
   	displayId = slider.getAttribute('display') // ID of associated display element.
	display = document.getElementById(displayId) // Get the associated display element.
	
	var w = display.value;
	var d = [];
	
	if (w == 0) {
		w = 0.01;
	}
	
	// Calculate the Normal CDF
	for (var i = 1; i <= 3; i+= 0.01) {
		var temp =  (i - 1) / (w * Math.sqrt(i * i + 1));
		d.push([i, normalCDF(temp, 0, 1) * 100]);
	}
	
	$.plot($("#placeholder"), 
			[ d ], 
			{
				xaxis: 
				{
					min:1,
					max:3
				},
				yaxis: 
				{
					min:50,
					max:100
				}
	});

	var pdf = new Array();
	for (var i = 1; i <= 10; i++) {
		pdf[i] = new Array();
		for (var j = 0; j < 11; j+= 0.05) {
			//pdf[i].push([j, normalPDF((j - i) / (w * i), 0, 1)  * 100]);
			pdf[i].push([j, normalPDF(j, i, w * i)  * 100]);
		}
	}
	
	$.plot($("#gaussianholder"), 
			[ pdf[1], pdf[2], pdf[3], pdf[4], pdf[5], 
			  pdf[6], pdf[7], pdf[8], pdf[9], pdf[10] ], 
			{
				xaxis: 
				{
					min:0,
					max:11
				},
				yaxis: 
				{
					min:0,
					max:200//110
				},
				colors: ["#CB2800", "#dba255", "#919733"]
	});
    //for (var i = 0; i < display.value; i += 0.5)
    //    d1.push([i, Math.sin(i)]);
    //var d2 = [[0, 3], [4, 8], [8, 5], [9, 13]];
    // a null signifies separate line segments
    //var d3 = [[0, 12], [7, 12], null, [7, 2.5], [12, 2.5]];    
    //$.plot($("#placeholder"), [ d1, d2, d3 ]);
}


// carpeGetElementsByClass: Cross-browser function that returns
// an array with all elements that have a class attribute that
// contains className
function carpeGetElementsByClass(className)
{
	var classElements = new Array()
	var els = document.getElementsByTagName("*")
	var elsLen = els.length
	var pattern = new RegExp("\\b" + className + "\\b")
	for (i = 0, j = 0; i < elsLen; i++) {
		if ( pattern.test(els[i].className) ) {
			classElements[j] = els[i]
			j++
		}
	}
	return classElements;
}
// carpeLeft: Cross-browser version of "element.style.left"
// Returns or sets the horizontal position of an element.
function carpeLeft(elmnt, pos)
{
	if (!(elmnt = document.getElementById(elmnt))) return 0;
	if (elmnt.style && (typeof(elmnt.style.left) == 'string')) {
		if (typeof(pos) == 'number') elmnt.style.left = pos + 'px';
		else {
			pos = parseInt(elmnt.style.left);
			if (isNaN(pos)) pos = 0;
		}
	}
	else if (elmnt.style && elmnt.style.pixelLeft) {
		if (typeof(pos) == 'number') elmnt.style.pixelLeft = pos;
		else pos = elmnt.style.pixelLeft;
	}
	return pos;
}
// carpeTop: Cross-browser version of "element.style.top"
// Returns or sets the vertical position of an element.
function carpeTop(elmnt, pos)
{
	if (!(elmnt = document.getElementById(elmnt))) return 0;
	if (elmnt.style && (typeof(elmnt.style.top) == 'string')) {
		if (typeof(pos) == 'number') elmnt.style.top = pos + 'px';
		else {
			pos = parseInt(elmnt.style.top);
			if (isNaN(pos)) pos = 0;
		}
	}
	else if (elmnt.style && elmnt.style.pixelTop) {
		if (typeof(pos) == 'number') elmnt.style.pixelTop = pos;
		else pos = elmnt.style.pixelTop;
	}
	return pos;
}
// moveSlider: Handles slider and display while dragging
function moveSlider(evnt)
{
	var evnt = (!evnt) ? window.event : evnt; // The mousemove event
	if (mouseover) { // Only if slider is dragged
		x = slider.startOffsetX + evnt.screenX // Horizontal mouse position relative to allowed slider positions
		y = slider.startOffsetY + evnt.screenY // Horizontal mouse position relative to allowed slider positions
		if (x > slider.xMax) x = slider.xMax // Limit horizontal movement
		if (x < 0.01) x = 0.01 // Limit horizontal movement
		if (y > slider.yMax) y = slider.yMax // Limit vertical movement
		if (y < 0) y = 0 // Limit vertical movement
		carpeLeft(slider.id, x)  // move slider to new horizontal position
		carpeTop(slider.id, y) // move slider to new vertical position
		sliderVal = x + y // pixel value of slider regardless of orientation
		sliderPos = (slider.distance / display.valuecount) * 
			Math.round(display.valuecount * sliderVal / slider.distance)
		v = Math.round((sliderPos * slider.scale + slider.from) * // calculate display value
			Math.pow(10, display.decimals)) / Math.pow(10, display.decimals)
		display.value = v / 100 // put the new value in the slider display element
		
			
		//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		showTest(slider);
	
		return false
	}
	return
}
// slide: Handles the start of a slider move.
function slide(evnt)
{
	if (!evnt) evnt = window.event; // Get the mouse event causing the slider activation.
	slider = (evnt.target) ? evnt.target : evnt.srcElement; // Get the activated slider element.
	dist = parseInt(slider.getAttribute('distance')) // The allowed slider movement in pixels.
	slider.distance = dist ? dist : carpeDefaultSliderLength // Deafault distance from global var.
	ori = slider.getAttribute('orientation') // Slider orientation: 'horizontal' or 'vertical'.
	orientation = ((ori == 'horizontal') || (ori == 'vertical')) ? ori : carpeSliderDefaultOrientation
		// Default orientation from global variable.
	displayId = slider.getAttribute('display') // ID of associated display element.
	display = document.getElementById(displayId) // Get the associated display element.
	display.sliderId = slider.id // Associate the display with the correct slider.
	dec = parseInt(display.getAttribute('decimals')) // Number of decimals to be displayed.
	display.decimals = dec ? dec : 0 // Default number of decimals: 0.
	val = parseInt(display.getAttribute('valuecount'))  // Allowed number of values in the interval.
	display.valuecount = val ? val : slider.distance + 1 // Default number of values: the sliding distance.
	from = parseFloat(display.getAttribute('from')) // Min/start value for the display.
	from = from ? from : 0 // Default min/start value: 0.
	to = parseFloat(display.getAttribute('to')) // Max value for the display.
	to = to ? to : slider.distance // Default number of values: the sliding distance.
	slider.scale = (to - from) / slider.distance // Slider-display scale [value-change per pixel of movement].
	
	if (orientation == 'vertical') { // Set limits and scale for vertical sliders.
		slider.from = to // Invert for vertical sliders. "Higher is more."
		slider.xMax = 0
		slider.yMax = slider.distance
		slider.scale = -slider.scale // Invert scale for vertical sliders. "Higher is more."
	}
	else { // Set limits for horizontal sliders.
		slider.from = from
		slider.xMax = slider.distance
		slider.yMax = 0
	}
	slider.startOffsetX = carpeLeft(slider.id) - evnt.screenX // Slider-mouse horizontal offset at start of slide.
	slider.startOffsetY = carpeTop(slider.id) - evnt.screenY // Slider-mouse vertical offset at start of slide.
	mouseover = true
	document.onmousemove = moveSlider // Start the action if the mouse is dragged.
	document.onmouseup = sliderMouseUp // Stop sliding.
	return false
}
// sliderMouseUp: Handles the mouseup event after moving a slider.
// Snaps the slider position to allowed/displayed value. 
function sliderMouseUp()
{
	if (mouseover) {
		v = (display.value) * 100 ? display.value * 100 : 1 // Find last display value.
		pos = (v - slider.from)/(slider.scale) // Calculate slider position (regardless of orientation).
		if (slider.yMax == 0) {
			pos = (pos > slider.xMax) ? slider.xMax : pos
			pos = (pos < 0) ? 0 : pos
			carpeLeft(slider.id, pos) // Snap horizontal slider to corresponding display position.
		}
		if (slider.xMax == 0) {
			pos = (pos > slider.yMax) ? slider.yMax : pos
			pos = (pos < 0) ? 0 : pos
			carpeTop(slider.id, pos) // Snap vertical slider to corresponding display position.
		}
		if (document.removeEventListener) { // Remove event listeners from 'document' (W3C).
			document.removeEventListener('mousemove', moveSlider, false)
			document.removeEventListener('mouseup', sliderMouseUp, false)
		}
		else if (document.detachEvent) { // Remove event listeners from 'document' (IE).
			document.detachEvent('onmousemove', moveSlider)
			document.detachEvent('onmouseup', sliderMouseUp)
		}
	}
	mouseover = false // Stop the sliding.
}
function focusDisplay(evnt)
{
	if (!evnt) evnt = window.event; // Get the mouse event causing the display activation.
	display = (evnt.target) ? evnt.target : evnt.srcElement; // Get the activated display element.
	lock = display.getAttribute('typelock') // Is the user allowed to type into the display?
	if (lock == 'on') {
		display.blur()
	}
	return
}
window.onload = function() // Set up the sliders and the displays.
{
	sliders = carpeGetElementsByClass(carpeSliderClassName) // Find the horizontal sliders.
	for (i = 0; i < sliders.length; i++) {
		sliders[i].onmousedown = slide // Attach event listener.
	}
	displays = carpeGetElementsByClass(carpeSliderDisplayClassName) // Find the displays.
	for (i = 0; i < displays.length; i++) {
		displays[i].onfocus = focusDisplay // Attach event listener.
		displays[i].value = 0.01
	}
	showTest(sliders[0]);
}
