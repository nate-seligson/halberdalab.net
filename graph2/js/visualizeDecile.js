var sliderDecile, decileFrameNum = 0; curDecileFrameQueue = 0, isPlayingDecile = false;
var path = location.href.substring(0,location.href.lastIndexOf("/")+1);
var startAge = 10, endAge = 81;

function playDecile() {
	if(decileFrameNum > 355) { //restart from the beginning or increment to next frame
		decileFrameNum = 0;
	} else {
		decileFrameNum += 1;
	}

	//if(decileFrameNum % 5 == 0) {
		sliderDecile.slider('value', decileFrameNum+startAge*5);//decileFrameNum/5+10);
		updateStats(Math.floor(decileFrameNum/5)+startAge);
	//}

	document.getElementById('decilePlot').src = decileData[decileFrameNum];
	curDecileFrameQueue = setTimeout("playDecile()", 100);
}

$(document).ready(function(e) {	
	sliderDecile = $('#sliderDecile').slider({ min: startAge*5, max: endAge*5,
		slide: function(e, ui) {
			if(isPlayingDecile) {
				clearTimeout(curDecileFrameQueue);
				isPlayingDecile = false;
				$( "#btnPlayDecile" ).text("Play");
			}
			updateStats(Math.floor(ui.value/5));//ui.value
			decileFrameNum = Math.round((ui.value-startAge*5));//10)*5);
			document.getElementById('decilePlot').src = decileData[decileFrameNum];
		},
		"value" : 20*5
	});
	
	$('#subHeading').html('Age Group: <span id="ageView">20</span> / People This Age: <span id="numPoints">3885</span>');
	
	$('#btnPlayDecile, #decilePlot').click(function(e) {
		$('#imgBtnPlay').css('display', 'none');
		if(isPlayingDecile) {
			clearTimeout(curDecileFrameQueue);
			isPlayingDecile = false;
			$( "#btnPlayDecile" ).text("Play");
		} else {
			isPlayingDecile = true;
			$( "#btnPlayDecile" ).text("Stop");
			curDecileFrameQueue = setTimeout("playDecile()", 100);
		}
	});
	
	$('#imgBtnPlay').click(function(e) { $('#btnPlayDecile').trigger('click'); });
	
	$('#btnSaveDecile, #saveDecileLink').click(function(e) {
		window.location.href = path+'retrieveDecileMovie.php';
	});
	
	$('#btnSaveDecile, #saveDecileLink').hover(function(e) {
		$('#btnSaveDecile').attr("src","images/scatterMovieSaveHover2.png");
		$('#saveDecileLink').css("color","#58C908");
	}, function(e) {
		$('#btnSaveDecile').attr("src","images/scatterMovieSave.png");
		$('#saveDecileLink').css("color","white");
	});
});