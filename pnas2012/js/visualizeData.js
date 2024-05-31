var path = location.href.substring(0,location.href.lastIndexOf("/")+1);
var plot, sliderGraph, sliderPNG;
var compositeCanvasCtx, plot, dataURLlist = [], dataURLlistWMeans = [];
var startAge = 10, endAge = 81;
var plotMT = 5, plotML = 55; //plot's top margin and left margin set to 30 (px)
var plotMarginLeft = 108, plotMarginTop = 33, plotWidth = 360, plotHeight = 379; //plot offset/dimensions within graph layer
var normalDelay = 100, wMeansDelay = 33;
var busy = false, meansSetting, scatterFrameNum = 0, curScatterFrameQueue, isPlayingScatter = false, isGeneratingMovie = false, graphExportCurAge, lastGraphDataNum; //states
var data, dataset, preset1; // datasets. external JS dependencies
var isPresetLoaded = false, isPresetLoadTriggered = false, presetLoadAutoPlay = false; presetLoadSliderValue = null,
presetLoadPrevSubText = '', presetLoadPrevModalText = ''; 
var tickDefs = {
		w: 		[0.1, 0.2, 0.3, 0.4, 0.5],
		rt:		[200, 600, 1000, 1400, 1800],
		math:	[0, 20, 40, 60, 80, 100]
}

var gridArray = [];
for (var i = 0; i < 4; i++) {
	gridArray[i] = [];
	for (var j = 0; j < 4; j++) {
		gridArray[i][j] = true;
	}
}
var plotConstraints = { age: startAge, w: [], rt: [], math: [], popMean: true, ovalAge: startAge };

for(i = 0; i < (tickDefs.w.length - 1); i++) { plotConstraints.w.push([ tickDefs.w[i], tickDefs.w[i+1] ]) }
for(i = 0; i < (tickDefs.rt.length - 1); i++) { plotConstraints.rt.push([ tickDefs.rt[i], tickDefs.rt[i+1] ]) }
for(i = 0; i < (tickDefs.math.length - 1); i++) { plotConstraints.math.push([ tickDefs.math[i], tickDefs.math[i+1] ]) }

var graphSettings = {
	math: [], gridArray: [],
	save: function() {
		this.math = plotConstraints.math.slice(0);
		for(i = 0; i < gridArray.length; i++)
			this.gridArray[i] = gridArray[i].slice(0);
	},
	isChanged: function() {
		if(plotConstraints.math.length != this.math.length)
			return true;
		
		for (i = 0; i < plotConstraints.math.length; i++)
			if(plotConstraints.math[i][0] != this.math[i][0])
				return true;
		
		for (i = 0; i < gridArray.length; i++) {
			if(gridArray[i].length != this.gridArray[i].length)
				return true;
			
			for(j = 0; j < gridArray[i].length; j++)
				if(gridArray[i][j] != this.gridArray[i][j])
					return true;
		}
		
		return false;
	}
};

function supportsCanvas() {
	return !!document.createElement('canvas').getContext;
}

function isGoodBrowser() { return supportsCanvas(); }

if (!isGoodBrowser()) {
	$('#viewer').hide();
	$('#nocanvas').show();
}

function playScatter() {
	if(scatterFrameNum >= ((plotConstraints.popMean == false) ? dataURLlist.length : dataURLlistWMeans.length)) { scatterFrameNum = 0; } //repeat animation
	document.getElementById('animation').src = ((plotConstraints.popMean == false) ? dataURLlist[scatterFrameNum] : dataURLlistWMeans[scatterFrameNum]);

	if (plotConstraints.popMean == true) {
		sliderNum = Math.floor(scatterFrameNum / 3) + startAge; // assumes two frames in between
		delay = wMeansDelay; // assumes two frames in between
	} else {
		sliderNum = scatterFrameNum + startAge;
		delay = normalDelay;
	}
	
	sliderPNG.slider('value', sliderNum);
	updateStats(sliderNum);
	
	scatterFrameNum++;
	curScatterFrameQueue = setTimeout("playScatter()", delay);
}

function exportImages() {
	numPoints = [];
	meansSetting = plotConstraints.popMean; //save current means state
	clearTimeout(curScatterFrameQueue);
	scatterFrameNum = 0; //reset frameCounter
	dataURLlist = []; dataURLlistWMeans = [];
	graphExportCurAge = startAge;
	plotConstraints.popMean = false;
	$('#cbShowPopMean2').attr('disabled', true); //disable graph's mean checkbox
	$('.cbConstraint').attr('disabled', true); //disable filtering checkboxes
	busy = true;  //disables play button + slider + group means functionality
	
	generateFrames();
}

function postRender() {
	plotConstraints.popMean = meansSetting;
	$('#cbShowPopMean2').removeAttr('disabled'); busy = false; //restore graph's play btn + means cb + slider
	$('.cbConstraint').removeAttr('disabled'); 
	$('.modal').hide();
	$('.modalMsg').hide();
	document.getElementById('animation').src = '';
	$('#graph').hide();
	scatterFrameNum = 0;
	
	if (!isGeneratingMovie) {
		$('#btnPlayScatter').trigger("click");
		$('#viewer').show();
	} else {
		generateMovieForDownload();
		$('#viewer').show();
		// TODO show user an image...
	}
}

/*function updateStatus() {
	if(graphExportCurAge < 81) {
		var percent = (Math.round((graphExportCurAge - 10) *1.4) > 100) ? 100 : Math.round((graphExportCurAge - 10) *1.4);
		//document.getElementById('percentComplete').innerHTML = percent + '% complete';
		updateStatus();
	}
}*/

function generateFrames() {
	plotConstraints.age = Math.floor(graphExportCurAge);
	plotConstraints.ovalAge = graphExportCurAge;
	importData();
	
	var plotCanvasCtx = plot.getCanvas().getContext('2d');
	compositeCanvasCtx.putImageData(plotCanvasCtx.getImageData(28,0,plotCanvasCtx.canvas.width - 28, plotCanvasCtx.canvas.height - 15), plotML + 28, plotMT);
	sliderGraph.slider('value', Math.floor(graphExportCurAge));
	
	if(plotConstraints.popMean == false) {
		dataURLlist.push(compositeCanvasCtx.canvas.toDataURL());
		/*var percent = Math.round(((Math.round((graphExportCurAge - startAge) *1.4) > 100) ? 100 : Math.round((graphExportCurAge - startAge) *1.4)) /2);*/
	} else {
		dataURLlistWMeans.push(compositeCanvasCtx.canvas.toDataURL());
		/*var percent = 50 + Math.round(((Math.round((graphExportCurAge - startAge) *1.4) > 100) ? 100 : Math.round((graphExportCurAge - startAge) *1.4)) /2);*/
	}
	
	//document.getElementById('percentComplete').innerHTML = percent + '% complete';
	
	if(graphExportCurAge < endAge) {
		if(plotConstraints.popMean) {// assumes 2 frames in between at x.33 and x.67
			// number has to be exactly right. must avoid double precision errors
			if(Math.round(graphExportCurAge*100 - Math.floor(graphExportCurAge)*100) == 33)
				graphExportCurAge = Math.floor(graphExportCurAge) + 0.67;
			else if(Math.round(graphExportCurAge*100 - Math.floor(graphExportCurAge)*100) == 67)
				graphExportCurAge = Math.floor(graphExportCurAge) + 1;
			else
				graphExportCurAge = Math.floor(graphExportCurAge) + 0.33;
		} else {
			graphExportCurAge++;
		}
		
		setTimeout("generateFrames()", 10);
	} else {
		if(plotConstraints.popMean == true) {
			postRender();
		} else {
			graphExportCurAge = startAge;
			plotConstraints.popMean = true;
			generateFrames();
		}
	}
}

function checkPointValidity(xVal, yVal, zVal, ageVal) {
	if(((plotConstraints.age - 3) > ageVal) || (ageVal > (plotConstraints.age + 3))) { return false; }
	var confirmedX = false, confirmedY = false, confirmedZ = false;
	
	if (xVal >= 0.1 && xVal <= 0.5 && yVal >= 200 && yVal <= 1800) {
		var xArr = Math.floor((xVal - 0.1) / 0.1);
		if (xArr == 4) { xArr = 3; }
		
		var yArr = Math.floor((yVal - 200) / 400);
		if (yArr == 4) { yArr = 3; }
		
		if (gridArray[xArr][yArr] == true) {
			confirmedX = true;
			confirmedY = true;
		}
	}
	
	for(j = 0; j < plotConstraints.math.length; j++) {
		if((plotConstraints.math[j][0] < zVal) && (zVal <= plotConstraints.math[j][1])) { confirmedZ = true; break;}
	}
	if(confirmedX && confirmedY && confirmedZ) { return true; } else { return false; }
}

function checkPointValidityOval(zVal, ageVal) {
	if(ageVal != plotConstraints.ovalAge) { return false; }
	var confirmedZ = false;
	for(j = 0; j < plotConstraints.math.length; j++) {
		if((plotConstraints.math[j][0] < zVal) && (zVal <= plotConstraints.math[j][1])) { confirmedZ = true; break;}
	}
	return confirmedZ;
}

function importData() {
	data = [];
	for(i = 0; i < dataset.length; i++) {
		if(checkPointValidity(dataset[i].d[0][0]/1000, dataset[i].d[0][1], dataset[i].m, dataset[i].a)) {
			var tempData = {};
			var r;
			if((dataset[i].a == (plotConstraints.age -1)) || (dataset[i].a == plotConstraints.age) || (dataset[i].a == (plotConstraints.age +1))) { r = 1; }
			else if((dataset[i].a == (plotConstraints.age -2)) || (dataset[i].a == (plotConstraints.age +2))) { r = .5; }
			else if((dataset[i].a == (plotConstraints.age -3)) || (dataset[i].a == (plotConstraints.age +3))) { r = .25; }
			
			tempData = {
				points: {fill: false, radius: r},/*fillColor: dataset[i].color, */
				color: dataColor[dataset[i].m],
				data: []
			};
			tempData.data.push([ dataset[i].d[0][0]/1000 , dataset[i].d[0][1] ]);
			data.push(tempData);
		}
	}
	
	$("#numPoints").html(data.length);
	$("#ageView").html(plotConstraints.age);
	numPoints.push(data.length);
	
	
	if(plotConstraints.popMean == true) {
		for(i = 0; i < datasetOval.length; i++) {
			if(checkPointValidityOval(datasetOval[i].m, datasetOval[i].a)) {
				var tempData = {};
				tempData = {
					lines:	{ show: true, lineWidth: 3},
					points:	{show: false},
					shadowSize: 0,
					color: dataColor[Math.round(datasetOval[i].m)],
					data: []
				};
				for(j=0; j < datasetOval[i].d.length; j++) {
					tempData.data.push([ datasetOval[i].d[j][0]/1000 , datasetOval[i].d[j][1] ]);
				}
				data.push(tempData);
			}
		}
		
		for(i = 0; i < datasetOvalCenter.length; i++) {
			if(checkPointValidityOval(datasetOvalCenter[i].m, datasetOvalCenter[i].a)) {
				var tempData = {};
				tempData = {
					lines:	{ show: true, lineWidth: 5},
					points:	{show: false},
					shadowSize: 0,
					color: dataColor[Math.round(datasetOvalCenter[i].m)],
					data: []
				};
				for(j=0; j < datasetOvalCenter[i].d.length; j++) {
					tempData.data.push([ datasetOvalCenter[i].d[j][0]/1000 , datasetOvalCenter[i].d[j][1] ]);
				}
				data.push(tempData);
			}
		}
		
		for(i = 0; i < datasetOvalGray.length; i++) {
			if(checkPointValidityOval(datasetOvalGray[i].m, datasetOvalGray[i].a)) {
				var tempData = {};
				tempData = {
					lines:	{ show: true, lineWidth: 3},
					points:	{show: false},
					shadowSize: 0,
					color: "#666666",
					data: []
				};
				for(j=0; j < datasetOvalGray[i].d.length; j++) {
					tempData.data.push([ datasetOvalGray[i].d[j][0]/1000 , datasetOvalGray[i].d[j][1] ]);
				}
				data.push(tempData);
			}
		}
	}
	plot.setData(data);
	plot.draw();
	var plotctx = document.getElementsByClassName('base')[0].getContext('2d');
	plotctx.save();
	
	plotctx.fillStyle = "#666666";
	for (var i = 0; i < 4; i++) {
		for (var j = 0; j < 4; j++) {
			if (gridArray[i][3 - j] == false) {
				plotctx.fillRect(34 + plotWidth/4 * i, 4 + (plotHeight - 4) / 4 * j, plotWidth/4 +1, plotHeight / 4);
			}
		}
	}
	//age no longer shown in graph
	/* plotctx.textAlign = "right";
	plotctx.font = "12px Arial";
	plotctx.fillStyle="#FFFFFF";
	plotctx.fillText('Age (yrs): ' + Math.floor(plotConstraints.age), 390, 23);
	plotctx.restore();
	*/
}

function affixGraphParts() {
	var graph = $('#placeholder');
	
	$('#placeholder').find(".tickLabel").remove();
	
	$('#placeholder').append('<canvas id="labels" width="620" height="450" style="position: absolute; left: 0px; top: 0px; "></canvas>');
	//$('#placeholder').append('<div id="areaPopMean" style="position: absolute; left: 330px; top: 430px;"><input id="cbShowPopMean" type="checkbox" value="popMean" /><label for="cbShowPopMean" style="white-sapce: nowrap;">Show <br />Group Means</label></div>');
	compositeCanvasCtx = document.getElementById('canvasOutput').getContext('2d');
	ctx = document.getElementById('labels').getContext('2d');
	//apply background to deal with gif transparency issue
	ctx.save();
	ctx.fillStyle = "#1A1A1A";
	ctx.fillRect(0,0,document.getElementById('labels').width, document.getElementById('labels').height);
	ctx.clearRect(plotML + 31, plotMT + 1, graph.width() - 33, graph.height() - 16);
	ctx.restore();
	
	//graph axis labels
	ctx.fillStyle="#FFFFFF";
	ctx.font = "bold 18px Arial";
	ctx.textAlign = "center";
	//ctx.fillText("ANS Precision and Math Ability across the Lifespan", plotML + parseInt(graph.width()/2) + 20, 18); //graph-title
	ctx.fillText("Weber Fraction (w)", plotML+parseInt(graph.width()/2)+(31/2), plotMT + parseInt(graph.height()) + 38); //xaxis
	
	ctx.save();
	ctx.rotate(-Math.PI/2);
	ctx.fillText("Response Time (ms)", -195, 33); //yaxis
	ctx.restore();
	
	ctx.save();
	ctx.rotate(-3 * Math.PI/2);
	ctx.fillText("Mathematical Ability", 195, -590);
	ctx.restore();
	
	ctx.save();
	ctx.font = "12px Arial";
	//y tick labels
	ctx.textAlign = "right";
	for(i=0; i < 5; i++) {
		ctx.fillText(1800-(i*400), plotML + 28, plotMT + 11 + (92.5*i));
	}
	
	//x tick labels
	ctx.textAlign = "center";
	ctx.fillText("0.1", plotML + 40, plotMT + 399);
	for(i=1; i < 4; i++) {
		ctx.fillText((0.1+(i*0.1)).toFixed(1), plotML + 33 + (91*i), plotMT + 399);
	}
	ctx.fillText("0.5", plotML + 390, plotMT + 399);
	
	
	//"better/worse" labels y, x, then z axis
	ctx.fillStyle = "#999";
	ctx.textAlign = "right";
	ctx.fillText('worse', plotML - 15, plotMT + 11);
	ctx.fillText('better', plotML - 15, plotMT + 400 - 19);
	
	ctx.textAlign = "left";
	ctx.fillText('better', plotML + 32, plotMT + 430);
	ctx.fillText('worse', plotML + 365, plotMT + 430);
	
	ctx.textAlign = "left";
	var legendXOffset = 40; //px
	ctx.fillText('better', plotML + 400 + legendXOffset + 83, plotMT + 7);
	ctx.fillText('worse', plotML + 400 + legendXOffset + 83, plotMT + 382);
	
	//better/worse tick bars y, x, then z axis
	ctx.strokeStyle = "#CCC";
	
	ctx.fillRect(plotML - 12, plotMT + 6, 10, 1);
	ctx.fillRect(plotML - 12, plotMT + 400 - 24, 10, 1);
	
	ctx.fillRect(plotML + 35, plotMT + 406, 1, 10);
	ctx.fillRect(plotML + 394, plotMT + 406, 1, 10);
	
	ctx.fillRect(plotML + 400 + legendXOffset + 70, plotMT + 2, 10, 1);
	ctx.fillRect(plotML + 400 + legendXOffset + 70, plotMT + 377, 10, 1);
	
	//add 6 ticks + ticklabels + label for colorbar
	ctx.fillStyle = "#FFF";
	ctx.strokeStyle = "#FFF";
	ctx.textAlign = "left";
	
	for(i = 0; i < 6; i++) {
		ctx.fillRect(plotML + parseInt(graph.width()) + legendXOffset + 30, plotMT + (i * 75) + 2, 10, 1);
		ctx.fillText((100 - (i * 20)), plotML + parseInt(graph.width()) + legendXOffset + 43, plotMT + (i * 75) + 7);
	}
	
	/*checkbox outlines - generate disposable canvas first */
	$('#placeholder').append('<canvas id="dispose" width="620" height="450" style="position: absolute; left: 0px; top: 0px; "></canvas>');
	disposableCtx = document.getElementById('dispose').getContext('2d');
	disposableCtx.fillStyle = "#FFF";
	disposableCtx.strokeStyle = "#FFF";
	//horizontal lines
	for(i = 0; i < 5; i++) {
		disposableCtx.fillRect(plotML + parseInt(graph.width()) + legendXOffset -20, plotMT + (i * 75) + 2 + ((i > 0) ? 2 : 0), 15, 1);
		disposableCtx.fillRect(plotML + parseInt(graph.width()) + legendXOffset -20, plotMT + (i * 75 + 73 + ((i == 4) ? 2 : 0)) + 2, 15, 1);
		disposableCtx.fillRect(plotML + parseInt(graph.width()) + legendXOffset -20, plotMT + (i * 75) + 2 + ((i > 0) ? 2 : 0), 1, 72 + ((i == 0 || i == 4) ? 2 : 0));
	}
	
	//add 5 checkboxes for color gradient
	for(i = 0; i < 5; i++) {
		$("#placeholder").append('<input checked="checked" class="cbConstraint" type="checkbox" value="z' + (4-i) +'" style="position: absolute; left: ' + (plotML + parseInt(graph.width()) + legendXOffset - 25) + 'px; top: ' + (plotMT + (75*i) + 34) + 'px;" />');
	}
	
	//** this part needs to run at the end (copy final graph background to compositeCanvas now)
	//affix right-side color gradient
	var legend_img = new Image();
	
	legend_img.src = 'images/color_bar.png';
	legend_img.onload = function() {
		ctx.drawImage(legend_img, plotML + parseInt(graph.width()) + legendXOffset, plotMT +1);
		compositeCanvasCtx.drawImage(legend_img, plotML + parseInt(graph.width()) + legendXOffset, plotMT +1);
		ctx.save();
	};
	compositeCanvasCtx.putImageData(ctx.getImageData(0,0,ctx.canvas.width, ctx.canvas.height), 0, 0);
	//compositeCanvasCtx.drawImage(legend_img, plotML + parseInt(graph.width()) + legendXOffset, plotMT +1);
	compositeCanvasCtx.save();
}

function generateMovieForDownload() {
	/*
	 * IMPORTANT NOTE:
	 * The preset uses .gifs to save on initial loading file size. This code generates .pngs because flot cannot
	 * reliably make gifs without server-side imagemagick. Thus, when you generate a new movie (aka animated gif),
	 * the data in dataURLlist MUST BE IN PNG format, meaning it CANNOT BE THE PRESET which is in gif format,
	 * unless the preset images are re-generated on the client. Thus, the animated gifs for the preset 
	 * must always exist on the server.
	 */
	var fileID = "", cbs = [], hexDef = [01, 02, 04, 08];
	if ($('.cbConstraint').length == 0) {
		fileID = "11111";
	} else {
		$('.cbConstraint').each(function (i) { cbs.push([$(this).val().substr(1,1), $(this).is(':checked')]); });
		for(i = 0; i < cbs.length; i++) { fileID += (cbs[i][1] == true ?  "1" : "0"); }
	}
	if (fileID == "11111") {
		window.location.href = path+'retrievePreset.php'+($('#cbShowPopMean').is(':checked') ? "?ovals=1" : ""); 
		return;
	}
	fileID += ($('#cbShowPopMean').is(':checked') ? "1" : "0");
	for(i = 0; i < gridArray.length; i++) {
		var counter = 0;
		for(j = 0; j < gridArray[i].length; j++) { if(!gridArray[i][j]) counter+= hexDef[j]; }
		fileID += (((counter+'').length < 2) ? "0"+counter : ""+counter);
	}
	
	var curSHeadingHTML = $('#subHeading').html();
	$('#subHeading').html('Processing Movie...');
	$.get('retrieveMovie.php?checkExists=1&fileID='+fileID, function(response) {
		if(response != "not found") {
			$('#subHeading').html('A download screen should come up momentarily...');
			window.location.href = path+'retrieveMovie.php?fileID='+fileID; 
			$('#subHeading').html(curSHeadingHTML);
		} else {
			isGeneratingMovie = true;
			$('#subHeading').html(curSHeadingHTML);
			if(graphSettings.isChanged()) {
				// need to reload dataURLlist and dataURLlistWMeans
				$('.modalMsg').show();
				$('.modal').show();
				graphSettings.save();
				setTimeout("exportImages()",10);
			} else {
				generateNewMovie(fileID);
			}
		}
	});
}

function generateNewMovie(fileID) {
	var curSHeadingHTML = $('#subHeading').html();
	var imageArraySpliced = [];
	var imageArraySpliced1 = [];
	var imageArraySpliced2 = [];
	var imageArraySpliced3 = [];
	var imageArraySpliced4 = [];
	var imageArraySpliced5 = [];
	var imageData = "";
	var imageData1 = "";
	var imageData2 = "";
	var imageData3 = "";
	var imageData4 = "";
	var imageData5 = "";
	var imageArray2Offset = 40;
	var imageArray3Offset = 70;
	var imageArray4Offset = 120;
	var imageArray5Offset = 175;

	if ($('#cbShowPopMean').is(':checked') == false) {
		for(i = 0; i < (dataURLlist.length); i++) {
			imageArraySpliced[i] = dataURLlist[i].replace('data:image/png;base64,','');
		}
		imageData = imageArraySpliced.join(',');
	} else {
		// limit to 75 array elements per upload... otherwise server cannot handle (timeout 3 minutes)
		// for simplicity, assume 225 elements max (currently 214)
		// this isn't clean, but it should work
		if (dataURLlistWMeans.length>75) {
			// 75 is too much for all options checked - images for age=20s are large... so do 35
			for(i = 0; i < imageArray2Offset; i++) { 
				imageArraySpliced1[i] = dataURLlistWMeans[i].replace('data:image/png;base64,','');
			}
			imageData1 = imageArraySpliced1.join(',');
			for(i = imageArray2Offset; i < imageArray3Offset; i++) {
				imageArraySpliced2[i-imageArray2Offset] = dataURLlistWMeans[i].replace('data:image/png;base64,','');
			}
			imageData2 = imageArraySpliced2.join(',');
			for(i = imageArray3Offset; i < imageArray4Offset; i++) {
				imageArraySpliced3[i-imageArray3Offset] = dataURLlistWMeans[i].replace('data:image/png;base64,','');
			}
			imageData3 = imageArraySpliced3.join(',');
			for(i = imageArray4Offset; i < imageArray5Offset; i++) {
				imageArraySpliced4[i-imageArray4Offset] = dataURLlistWMeans[i].replace('data:image/png;base64,','');
			}
			imageData4 = imageArraySpliced4.join(',');
			for(i = imageArray5Offset; i < dataURLlistWMeans.length; i++) {
				imageArraySpliced5[i-imageArray5Offset] = dataURLlistWMeans[i].replace('data:image/png;base64,','');
			}
			imageData5 = imageArraySpliced5.join(',');
		} else {
			for(i = 0; i < dataURLlistWMeans.length; i++) {
				imageArraySpliced[i] = dataURLlistWMeans[i].replace('data:image/png;base64,','');
			}
			imageData = imageArraySpliced.join(',');
		}
	}

	chainId = Math.floor(Math.random()*900000)+100000; // 6 digit #
	if (imageData4) {
		$('#subHeading').html('Uploading data (' + Math.round((imageData1.length+imageData2.length+imageData3.length+imageData4.length+imageData5.length)/1000000) + 'MB).  This may take a few minutes. <img src="images/spinner.gif"/>');
		
		// chain the posts together
		$.post("processVideo.php", { "fileID": fileID, "delay": ($('#cbShowPopMean').is(':checked') ? "3" : "10"), "imageData": imageData1, "chainId": chainId, "skipGif": "1" }).complete(function() {
		// don't really need to wait for data1 to finish processing before starting to upload data2
		// part of the wait time is upload and the other part is server processing
		// they can be pipelined to some degree, with the assumption that data1 will finish processing before data2 + data3... - this is not yet implemented.
			$.post("processVideo.php", { "fileID": fileID, "delay": ($('#cbShowPopMean').is(':checked') ? "3" : "10"), "imageData": imageData2, "chainId": chainId, "offset": imageArray2Offset, "skipGif": "1" }).complete(function() {
				$.post("processVideo.php", { "fileID": fileID, "delay": ($('#cbShowPopMean').is(':checked') ? "3" : "10"), "imageData": imageData3, "chainId": chainId, "offset": imageArray3Offset, "skipGif": "1" }).complete(function() {
					$.post("processVideo.php", { "fileID": fileID, "delay": ($('#cbShowPopMean').is(':checked') ? "3" : "10"), "imageData": imageData4, "chainId": chainId, "offset": imageArray4Offset, "skipGif": "1" }).complete(function() {
						$.post("processVideo.php", { "fileID": fileID, "delay": ($('#cbShowPopMean').is(':checked') ? "3" : "10"), "imageData": imageData5, "chainId": chainId, "offset": imageArray5Offset }).complete(function() {
							$.get('retrieveMovie.php?checkExists=1&fileID=' + fileID, function(response) {
								if(response != "not found") { window.location.href = path+'retrieveMovie.php?fileID='+fileID; }
								else {
									alert('An error occured when encoding the video.');
								}
								$('#subHeading').html(curSHeadingHTML);
							});
						});
					});
				});
			});
		});
	} else {
		$('#subHeading').html('Uploading data (' + Math.round(imageData.length/1000000) + 'MB).  This may take a few minutes. <img src="images/spinner.gif"/>');
		
		$.post("processVideo.php", { "fileID": fileID, "delay": ($('#cbShowPopMean').is(':checked') ? "3" : "10"), "imageData": imageData, "chainId": chainId }).complete(function() {
			$.get('retrieveMovie.php?checkExists=1&fileID=' + fileID, function(response) {
				if(response != "not found") { window.location.href = path+'retrieveMovie.php?fileID='+fileID; }
				else {
					alert('An error occured when encoding the video.');
				}
				$('#subHeading').html(curSHeadingHTML);
			});
		});
	}
	isGeneratingMovie = false;
}

function isOnMobileDevice() {
	return screen.width < 500 ||
			navigator.userAgent.match(/Android/i) ||
			navigator.userAgent.match(/webOS/i) ||
			navigator.userAgent.match(/iPhone/i) ||
			navigator.userAgent.match(/iPod/i) || 
			navigator.userAgent.match(/iPad/i);
}

var cannotRunOnMobileStr = "Sorry, this functionality cannot be performed on a mobile device due to memory limitations. Please visit the site on a desktop or notebook computer and try again.";

function loadScatterPreset(autoPlay, sliderValue) {
	//save text and change text
	presetLoadPrevSubText = $('#subHeading').html();
	presetLoadPrevModalText = $('.modalMsg').html();
	$('#subHeading').html('Loading data from 13,554 individuals... <img src="images/spinner.gif"/>');
	$('.modalMsg').html('<h3>Loading...</h3>');
	$('.modal').show();
	
	// separate the action part of the function to handle new code to load preset after page load
	// now, if the preset has not finished loading when the user clicks play or moves the slider,
	// then the appropriate vars are set so that when the preset js finishes loading, the action
	// triggered earlier (start playing the movie, or show frame x) will automatically start.
	// if the preset has finished loading when the user clicks play or moves the slider, everything
	// works just as before. 
	// a bunch of global vars had to be added to make this partial hack work.
	if (isPresetLoaded)
		loadScatterPresetAction(autoPlay, sliderValue);
	else {
		// store the parameters globally, call from scatter.php post-preset1-js load
		presetLoadAutoPlay = autoPlay;
		presetLoadSliderValue = sliderValue;
	}
	isPresetLoadTriggered = true;
}

function loadScatterPresetPostLoad() {
	isPresetLoaded = true;
	if (isPresetLoadTriggered) {
		loadScatterPresetAction(presetLoadAutoPlay, presetLoadSliderValue);
	}
}

function loadScatterPresetAction(autoPlay, sliderValue) {
	dataURLlist = preset1;
	dataURLlistWMeans = ovalpreset1;
	$('#subHeading').html(presetLoadPrevSubText);
	$('.modalMsg').html(presetLoadPrevModalText);
	$('.modal').hide();
	if(autoPlay) {
		$('#btnPlayScatter').trigger('click');
	} else {
		scatterSliderChange(sliderValue);
	}
}

function scatterSliderChange(value) {
	if(dataURLlist.length != 0) {
		if(isPlayingScatter) {
			clearTimeout(curScatterFrameQueue);
			isPlayingScatter = false;
			$( "#btnPlayScatter" ).text("Play");
		}
		
		scatterFrameNum = value - startAge;
		if (plotConstraints.popMean)
			scatterFrameNum *= 3;
		updateStats(value);
		document.getElementById('animation').src = ((plotConstraints.popMean == false) ? dataURLlist[scatterFrameNum] : dataURLlistWMeans[scatterFrameNum]);
	}
}

$(document).ready(function(e) {
	//$('body').css('background-color', 'white');
	$('.modal').css('top', plotMT + 106); $('.modal').css('left', plotML + 35);
	
	sliderPNG = $('#sliderPNG').slider({ min: startAge, max: endAge,
		slide: function(e, ui) {
			scatterSliderChange(ui.value);
		},
		change: function(e, ui) {
			if(dataURLlist.length == 0) {
				loadScatterPreset(false, ui.value);
			}
		},
		"value" : 20
	});
	
	$('#btnPlayScatter').click(function(e) {
		if(dataURLlist.length == 0) {
			loadScatterPreset(true, null);
		} else {
			$('#imgBtnPlay').css('display', 'none');
			if(isPlayingScatter) {
				clearTimeout(curScatterFrameQueue);
				$("#btnPlayScatter").text("Play");
				isPlayingScatter = false;
			} else {
				isPlayingScatter = true;
				$("#btnPlayScatter").text("Stop");
				curScatterFrameQueue = setTimeout("playScatter()", normalDelay);
			}
		}
	});
	
	$('#imgBtnPlay').click(function(e) { $('#btnPlayScatter').trigger('click'); });
	
	$('.cbConstraint').live('click', function(e) {
		var cRS = parseInt($(this).val().substring(1,2));
		if($(this).is(':checked')) {
			plotConstraints.math.splice(cRS, 0, [tickDefs.math[cRS], tickDefs.math[cRS+1]]);
		} else {
			for(i = 0; i < plotConstraints.math.length; i++) {
				if(plotConstraints.math[i][0] == tickDefs.math[cRS]) { plotConstraints.math.splice(i, 1); break; }
			}
		}
		importData();
	});
	
	$('#btnViewMovie').click(function(e) {
		if(busy) { return; }
		if(!graphSettings.isChanged()) {
			sliderPNG.slider('value', $('#sliderGraph').slider('value'));
			scatterFrameNum = $('#sliderGraph').slider('value') - startAge;
			//if (plotConstraints.popMean)
			//	scatterFrameNum *= 3;
			//document.getElementById('animation').src = ((plotConstraints.popMean == false) ? dataURLlist[scatterFrameNum] : dataURLlistWMeans[scatterFrameNum]);
			$('#viewer').show();
			$('#graph').hide();
			$('#btnPlayScatter').trigger("click");
		} else {
			$('.modalMsg').show();
			$('.modal').show();
			graphSettings.save();
			setTimeout("exportImages()",10);
		}
	});
	
	$('#btnInteract').click(function(e) {
		if(isOnMobileDevice()) {
			alert(cannotRunOnMobileStr);
			return;
		}
	
		if(isPlayingScatter) {
			clearTimeout(curScatterFrameQueue);
			isPlayingScatter = false;
			$("#btnPlayScatter").text("Play");
		}
		
		$('#viewer').hide();
		$('#graph').show();
		
		sliderGraph = $( "#sliderGraph" ).slider({ min:startAge, max: endAge,
			change: function(e, ui) {
				if(busy) { return; }
				plotConstraints.age = ui.value;
				plotConstraints.ovalAge = ui.value;
				$("#ageView").html(ui.value);
				importData();
			},
			slide: function(e, ui) {
				if(busy) { return; }
				updateStats(ui.value);
			},
			value: $('#sliderPNG').slider('value')
		});
		
		
		if(data == null || $.plot == null) {
			//save text and change text
			var prevSubText = $('#subHeading').html();
			$('#subHeading').html('Loading interactive graph... <img src="images/spinner.gif"/>');
			
			$LAB.script("js/data.js"/*?_"+Math.random()*/).wait(function() {
				data = dataset;
			})
			.script('js/jquery.flot.js').wait(function() {
				plot = $.plot($("#placeholder"), data, {
					xaxis:	{ min: 0.1, max: 0.5, ticks: 4 },
					yaxis:	{ min: 200, max: 1800, ticks: [200,600,1000,1400,1800] },
					series:	{ points: { show: true, fill: true, fillColor: null }, shadowSize: 0 },
					grid:	{ canvasText: {show: true, font: "sans 9px"}, color: "#FFFFFF", backgroundColor: { colors: ["#1A1A1A", "#1A1A1A"] } }
				});
				$('.base').css('margin-top', plotMT + 'px');
				$('.base').css('margin-left', plotML + 'px');
				
				affixGraphParts();
				sliderGraph.slider('value', $('#sliderPNG').slider('value'));
				
				$('#subHeading').html(prevSubText);
				graphSettings.save();
				$('#btnInteract').trigger('click');
			});
		} else {
			sliderGraph.slider('value', $('#sliderPNG').slider('value'));
		}
	});
	
	$('#cbShowPopMean, #cbShowPopMean2').bind("click", function(e) {
		if(busy) { return; }
		var checked = $(this).is(':checked');
		plotConstraints.popMean = checked;
		$("#cbShowPopMean").prop("checked", checked); $("#cbShowPopMean2").prop("checked", checked);
		
		if($('#viewer').css('display') == 'block') {
			if(dataURLlist.length == 0) {
				document.getElementById('animation').src = ($("#cbShowPopMean").prop("checked") == true ? 'images/preset1Means.png' : 'images/preset1.png');
			} else {
				if (plotConstraints.popMean == true) {
					scatterFrameNum = Math.floor(scatterFrameNum * 3);
				} else {
					scatterFrameNum = Math.floor(scatterFrameNum / 3);
				}
					
				if(isPlayingScatter) {
					//clear queued image frames, and start animation again
					clearTimeout(curScatterFrameQueue);
					curScatterFrameQueue = setTimeout("playScatter()", 100);
				} else {
					document.getElementById('animation').src = ((plotConstraints.popMean == false) ? dataURLlist[scatterFrameNum] : dataURLlistWMeans[scatterFrameNum]);
				}
			}
		} else {
			importData();
		}
	});
	
	$('#dispose').live("click", function(e) {
		var x = e.layerX - plotML - 35;
		var y = e.layerY - plotMT;
		
		var xArr = null;
		var yArr = null;
		
		if (y > 0 && y <= plotHeight / 4) { yArr = 3;}
		else if (y > plotHeight / 4 && y <= plotHeight / 4 * 2) {	yArr = 2; }
		else if (y > plotHeight / 4 * 2 && y <= plotHeight / 4 * 3) { yArr = 1; }
		else if (y > plotHeight / 4 * 3 && y <= plotHeight / 4 * 4) { yArr = 0; }
		
		if (x >= 0 && x <= plotWidth / 4) { xArr = 0; }
		else if (x > plotWidth / 4 && x <= plotWidth / 4 * 2) {	xArr = 1; }
		else if (x > plotWidth / 4 * 2 && x <= plotWidth / 4 * 3) {	xArr = 2; }
		else if (x > plotWidth / 4 * 3 && x <= plotWidth / 4 * 4) { xArr = 3; }
		if(yArr != null && xArr != null) {
			if (gridArray[xArr][yArr]) {
				gridArray[xArr][yArr] = false;
			}else {
				gridArray[xArr][yArr] = true;
			}
			
			importData();
			// x-left: 111
			// x-right: 472
			// y-top: 33
			// y-bottom: 412
		}
	});
	
	$('#btnSaveScatter, #saveScatterLink').click(function(e) {
		if(isOnMobileDevice()) {
			alert(cannotRunOnMobileStr);
			return;
		}
		if(!isGoodBrowser()) {
			return;
		}
		generateMovieForDownload();
	});
	
	$('#btnSaveScatter, #saveScatterLink').hover(function(e) {
		$('#btnSaveScatter').attr("src","images/scatterMovieSaveHover2.png");
		$('#saveScatterLink').css("color","#58C908");
	}, function(e) {
		$('#btnSaveScatter').attr("src","images/scatterMovieSave.png");
		$('#saveScatterLink').css("color","white");
	});
	
	
	$("a.movementimg").fancybox({
		'titlePosition'		: 'outside',
		'overlayColor'		: '#000',
		'overlayOpacity'	: 0.9,
		'speedOut'			: 200
	});
	
	firstImg = new Image(); firstImg.src = "images/FirstMovement.gif";
	secondImg = new Image(); secondImg.src = "images/SecondMovement.gif";
	thirdImg = new Image(); thirdImg.src = "images/ThirdMovement.gif";
	
	$(window).bind('blur', function() {
		if(isPlayingScatter) {
			$('#btnPlayScatter').trigger('click');
		}
	});
});