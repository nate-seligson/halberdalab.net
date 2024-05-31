<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="utf-8" />
	<title>Number Sense | Scatter Plot</title>
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
	<script type="text/javascript">
		(function(g,b,d){var c=b.head||b.getElementsByTagName("head"),D="readyState",E="onreadystatechange",F="DOMContentLoaded",G="addEventListener",H=setTimeout;
		function f(){
		   $LAB
		   .setOptions({ UsePreloading:false })
		   .script('js/jquery-1.6.2.min.js').wait()
		   .script('js/jquery-ui-1.8.11.custom.min.js').wait()
		   .script('js/jquery.fancybox-1.3.4.pack.js').wait()
		   .script('js/visualizeData.js?_'+Math.random()).wait()
		   .script('js/data.numPoints.js').wait()
		   .script("js/data.preset1.js").wait(function() {loadScatterPresetPostLoad()});
		}
		H(function(){if("item"in c){if(!c[0]){H(arguments.callee,25);return}c=c[0]}var a=b.createElement("script"),e=false;a.onload=a[E]=function(){if((a[D]&&a[D]!=="complete"&&a[D]!=="loaded")||e){return false}a.onload=a[E]=null;e=true;f()};

		a.src="js/LAB.js";

		c.insertBefore(a,c.firstChild)},0);if(b[D]==null&&b[G]){b[D]="loading";b[G](F,d=function(){b.removeEventListener(F,d,false);b[D]="complete"},false)}})(this,document);
	</script>
	<link rel="stylesheet" type="text/css" href="css/south-street/jquery-ui-1.8.11.custom.css" />
	<link rel="stylesheet" type="text/css" href="css/styles.css" />
	<!--[if lte IE 8]><script language="javascript" type="text/javascript" src="js/excanvas.min.js"></script><![endif]-->
	<link href='http://fonts.googleapis.com/css?family=Droid+Sans:regular,bold&v1' rel='stylesheet' type='text/css'>
	<link rel="stylesheet" href="css/fancybox/jquery.fancybox-1.3.4.css" type="text/css" media="screen" />
</head>
<body>
	<div style="margin: auto; padding: 0 5px; width: 970px; height: 100%;">
		<div style="height: 32px; background-color: #1A1A1A; position: fixed; width: 970px;">
			<div id="topmenu" align="right">
				<div id="topmenuinner">
					<a href="index.html">Home</a> | <a href="decile.html">View Decile Plot</a> | <a href="http://panamath.org">Test yourself <img src="images/panamathHeadGray.png"/></a>
				</div>
			</div>
		</div>
		<div id="mainContent" style="position: fixed;">
			<div id="heading" style="margin-bottom: -5px; font-size: 4em;">Scatter Plot</div>
			<div id="subHeading" class="white" style="font-size: 1.5em;">Age Group: <span id="ageView">20</span> / Points Plotted: <span id="numPoints">3885</span></div>
			<div style="position: relative;">
				<div class="modal" style="position: absolute; display: none; top: 111px; left: 90px; height: 373px; width: 361px; background-color: #000; opacity: 0.7; z-index: 10; text-align: center;">
					<div class="modalMsg" style="position: relative; top: 44%;">
						<h3>Processing...<br/>This may take several minutes.</h3>
						<span id="percentComplete"></span>
					</div>
				</div>
				<div id="viewer" style="width: 620px;">
					<div style="height: 90px; margin-top: 8px; margin-bottom: 12px;">
						<div style="float:left; width: 100px;"><span id="btnPlayScatter" class="button">Play</span></div>
						<div style="float:left; margin-top: 3px; width: 355px;">
							<div id="sliderPNG" class="sliderBar" style="width: 19em; margin: 13px 0 3px;"></div>
							<div style="width: 21em;">
								<div class="sliderTickBars"><span>|</span><span>|</span><span>|</span><span>|</span><span>|</span><span>|</span><span>|</span><span>|</span></div>
								<div class="sliderTicks"><span>10</span><span>20</span><span>30</span><span>40</span><span>50</span><span>60</span><span>70</span><span>80</span></div>
								<div class="sliderLabel">Age (years)</div>
							</div>
						</div>
						<div align="center" style="float:left; width: 165px;">
							<span id="btnInteract" class="button">Filter Ability</span>
							<span>
								<div align="center" style="float:left; width: 165px; margin-top: 8px;">
									<div style="display: inline-block;">
										<input id="cbShowPopMean" type="checkbox" checked='checked' value="popMean" style="float:left; margin: 12px 5px 0px 0px;" />
										<label style="display: inline-block;" for="cbShowPopMean"><img style="vertical-align: top;" src="images/ovalsSmall.png" />
											<span style="display:inline-block; color: white; font-size: 0.95em; font-weight: bold;">Group<br />Means</span>
										</label>
									</div>
								</div>
							</span>
						</div>
						<div class="clear"></div>
					</div>
					<div>
						<img id="animation" src="images/preset1Means.png" style="position:relative; top: 0px; left: 0px; z-index: 1;" />
						<!---<img id="imgBtnPlay" src="images/btnPlay.png" style="position: relative; z-index: 2; top: -321px; left: 200px; display: inline;" />--->
					</div>
				</div>
				<div id="graph" style="width: 620px; display: none;">
					<div style="height: 90px; margin-top: 8px; margin-bottom: 12px;">
						<div style="float:left; width: 100px;"><span id="btnViewMovie" class="button">Play</span></div>
						<div style="float:left; margin-top: 3px; width: 355px;">
							<div id="sliderGraph" class="sliderBar" style="width: 19em; margin: 13px 0 3px;"></div>
							<div style="width: 21em;">
								<div class="sliderTickBars"><span>|</span><span>|</span><span>|</span><span>|</span><span>|</span><span>|</span><span>|</span><span>|</span></div>
								<div class="sliderTicks"><span>10</span><span>20</span><span>30</span><span>40</span><span>50</span><span>60</span><span>70</span><span>80</span></div>
								<div class="sliderLabel">Age (years)</div>
							</div>
						</div>
						<div align="center" style="float:left; width: 165px;">
							<span class="button" style="background-color: #1E1E1E; border: solid 1px white; padding: 3px 19px; cursor: default;">Filter Ability</span>
							<span>
								<div align="center" style="float:left; width: 165px; margin-top: 8px;">
									<div style="display: inline-block;">
										<input id="cbShowPopMean2" type="checkbox" checked='checked' value="popMean" style="float:left; margin: 12px 5px 0px 0px;" />
										<label style="display: inline-block;" for="cbShowPopMean"><img style="vertical-align: top;" src="images/ovalsSmall.png" />
											<span style="display:inline-block; color: white; font-size: 0.95em; font-weight: bold;">Group<br />Means</span>
										</label>
									</div>
								</div>
							</span>
						</div>
						<div class="clear"></div>
					</div>
					<div id="placeholder" style="width:400px;height:400px;"></div>
				</div>
				<div id="nocanvas" style="width: 590px; display:none; margin: 45px 20px 45px 0; padding: 15px; border: 1px solid red;">
					<p style="margin-bottom: 1em;">We're sorry. Our interactive features are not supported by your browser. Please upgrade to the newest version of your browser or use a newer, different browser installed on your computer to access our website.</p>
					<p style="margin-bottom: 1em;">Below are links to download the latest versions of popular browsers.</p>
					<ul style="margin-left: 2em;">
						<li><a href="http://www.mozilla.com/">Mozilla Firefox</a></li>
						<li><a href="http://www.google.com/chrome/">Google Chrome</a></li>
						<li><a href="http://windows.microsoft.com/en-US/internet-explorer/products/ie/home">Internet Explorer</a></li>
						<li><a href="http://www.apple.com/safari/">Safari</a></li>
						<li><a href="www.opera.com/">Opera</a></li>
					</ul>
				</div>
			</div>
		</div>
		<div id="sidebar" style="margin: 20px 0px 0px 640px; padding: 20px 0px 0px 20px; width: 310px; border-left: 1px solid #CCC; font-size: 0.9em; line-height: 1.35em;">
			<div class="sectionHeader">Overview</div>
			<p>In this graph, each person is a dot that emerges as we reach their age at the time of testing and then fades away. The color of their dot is the person's self-reported school mathematics ability, and their dot appears at a position indicating the precision of their Approximate Number System (ANS): their acuity (Weber fraction (w)) and Response Time (ms) during the ANS dots test.</p>
			<br />
			<div class="sectionHeader">Interact</div>
			<p>
				Some things to try:</p>
				<table id="tblInteract" cellpadding="0" border="0" style="margin-bottom: 5px;">
				<tr><td width="118px;"><img src="images/scatterInteractDrag2.png" style="border: solid 1px #929292;" class="sideImage" /></td><td style="padding-bottom: 10px;">Drag the age cursor to move the data cloud.</td></tr>
				<tr><td><img src="images/scatterInteractMeans2.png" style="border: solid 1px #929292;" class="sideImage" /></td><td style="padding-bottom: 10px;">Click Group Means to turn ovals on and off.</td></tr>
				<tr><td><img src="images/scatterInteractFilter2.png" style="border: solid 1px #929292;" class="sideImage" /></td><td style="padding-bottom: 10px;">Press Filter Ability to turn groups on and off.</td></tr>
				</table>
				<p>Dragging the age cursor yourself can be helpful if the movie looks choppy.</p>
			<br />
			<div class="sectionHeader">The Task<img src="images/scatterTask.png" style="vertical-align: bottom; padding-left: 10px;" /></div>
			<p>People freely navigated to our website to test their own Number Sense (visit <a target="_blank" href="http://panamath.org">panamath.org</a> to test yourself). They saw brief flashes of dots and had to decide if there were more blue or more yellow dots in the flash. Individuals with a more precise Number Sense are more accurate (i.e., a smaller Weber fraction) and faster (i.e., a low Response Time).</p>
			<br />
			<div>
				<img src="images/ovalsBig.png" style="float:right;" />
				<div class="sectionHeader">Group Means</div>
				<p>The ovals in the plot indicate the 10th - 90th percentile range in ANS precision (w, Response Time) and the '+' indicates the mean precision for a group. The color indicates the group's mean mathematical ability. Notice that the red oval tends to be on the lower left (ie., better ANS performance) and the green & yellow ovals tend to be on the upper right (i.e., worse ANS performance).</p>
			</div>
			<br />
			<div class="sectionHeader">Finding Patterns</div>
			<p>Seeing patterns among 10,000+ data points can be challenging. This interactive plot can help. Some things you may notice:</p>
			<br />
			<div class="sectionHeader">Developmental Change</div>
			<p>Three major movements in the data:
				<ul>
					<li>First movement (&asymp; 10-16 yrs.) &mdash; The data cloud emerges as Response Times move down towards 600 ms. -&nbsp;<a class="movementimg" rel="movementgroup" href="images/FirstMovement.gif" title="First movement (&asymp; 10-16 yrs.) &mdash; The data cloud emerges as Response Times move down towards 600 ms.">watch</a></li>
					<li>Second movement <img src="images/scatterDevChg2.png" align="right" style="margin: 10px;"/>(&asymp; 16-30 yrs.) &mdash; The data cloud shifts towards the lower left of the graph (better performance) and forms a hotspot; best performance occurs at approximately 30 years of age. -&nbsp;<a class="movementimg" rel="movementgroup" href="images/SecondMovement.gif" title="Second movement (&asymp; 16-30 yrs.) &mdash; The data cloud shifts towards the lower left of the graph (better performance) and forms a hotspot; best performance occurs at approximately 30 years of age.">watch</a></li>
					<li>Third movement (&asymp; 30-81 yrs.) &mdash; The data cloud dissolves, becomes erratic, and performance drifts up and out from the lower left hotspot (towards worse performance). -&nbsp;<a class="movementimg" rel="movementgroup" href="images/ThirdMovement.gif" title="Third movement (&asymp; 30-81 yrs.) &mdash; The data cloud dissolves, becomes erratic, and performance drifts up and out from the lower left hotspot (towards worse performance).">watch</a></li>
				</ul>
			</p>
			<br />
			<div>
				<div class="sectionHeader">Mathematical Ability</div>
				<p>This relationship is best viewed by clicking on the "Filter Ability" button which brings up checkboxes <img src="images/scatterMathAb3.png" align="left" class="sideImage" style="margin: 15px 15px 15px 0px; border: 1px solid #929292;" />next to the Mathematical Ability rainbow bar. Clicking on the two boxes next to the blue and cyan values (40 - 80 on the rainbow) will remove these points from the graph. Among the remaining values, the cloud tends to be redder on the lower left corner (better performance) and greener on the upper right (worse performance). This is particularly evident during the years of better performance (15 - 30 yrs.), seen by dragging the age cursor.
					<!--<img src="images/scatterMathAge2.png" style="margin: 10px 5px 20px; border: solid 1px #929292;" class="sideImage" />-->
					<ul style="margin-top: 6px;  margin-left: 0;">
						<li style="color: green; margin-bottom: 6px;"><span class="normalFColor"><img align="right" class="sideImage" style="margin: 5px 5px 5px 7px; border: 1px solid #929292;" src="images/scatterMathGreen2.png" />Green dots are people who report they were not good in mathematics class in school (and they are doing worse on the ANS task &mdash; upper right of cloud).</span></li>
					</ul>
					
					<img align="left" class="sideImage" style="margin: 5px 10px 5px 0; border: 1px solid #929292;" src="images/scatterMathRed2.png" />
					<ul>
						<li style="color:red; margin-bottom: 6px;"><span class="normalFColor">Red dots are people who report they were good in mathematics class in school (and they are doing better on the ANS task &mdash; lower left of cloud).</span></li>
					</ul>
					You may also notice that Green dots tend to be more diffuse while Red dots show more of a hotspot in the lower left corner &mdash; this is consistent with Green individuals presenting with more variable abilities.
				</p>
			</div>
			<br />
			<div class="sectionHeader">Saving Your Movies</div>
			<p>We've made this interactive data graph recordable so that you can create a copy of the movie to show in your own presentations without being connected to the web. The recordable movie will look like the one you are currently watching. You can change the graph settings and record several distinct movies.</p>
			<div style="height:76px; margin: 10px 20px;">
				<img id="btnSaveScatter" src="images/scatterMovieSave.png" align="left" style="padding-right: 10px; cursor: pointer;" alt="Save movie to your computer"/>
				<div style="padding-top: 15px;">
					<span id="saveScatterLink" alt="Save movie to your computer">Save Movie</span><br />
					<span>(Animated GIF: &asymp; 4 MB)</span>
				</div>
			</div>
			<p>Clicking the Save Movie button above opens a dialog box where you can name the file and save it to your own computer. The movie will be an animated .gif file approximately 4 MB in size. To play the movie, open this file in QuickTime, a web browser, or copy it to Microsoft Powerpoint and view it in Slide Show mode.</p>
			<br/>
			<!--<p class="copyright">&copy; 5.5.2011+</p>-->
		</div>
		<div class="clear"></div>
	</div>
	<canvas id="canvasOutput" width="620px" height="450px" style="display:none;"></canvas>
</body>
</html>