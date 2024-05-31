<?php 
if(isset($_GET["fileID"])) {
	$prefix = "plotPresets/";
	$gifFileName = "animation".$_GET["fileID"].".gif";
	if(file_exists($prefix.$gifFileName)) {
		if (isset($_GET["checkExists"])) {
			echo "found";
		} else {
			header ( 'Content-type:image/gif' );
			header ( 'Content-disposition:attachment;filename=number_sense_math_animation.gif' );
			//header ( 'Content-Length: '.filesize($prefix.$gifFileName));
			
			ob_clean();
			flush();
			readfile($prefix.$gifFileName);
		}
	} else {
		echo "not found";
	}
}
/*if(isset($_GET["plotType"])) {
	if($_GET["plotType"] == "defaultScatter") {
		$gifFileName = 'scatterPlot.gif';
	} elseif ($_GET["plotType"] == "scatterWithMean") {
		$gifFileName = 'scatterWithMean.gif';
	} elseif ($_GET["plotType"] == "scatterHighMath") {
		$gifFileName = 'scatterHighMath.gif';
	} elseif ($_GET["plotType"] == "scatterLowMath") {
		$gifFileName = 'scatterLowMath.gif';
	}
	header ( 'Content-type:image/gif' );
	header ( 'Content-disposition:attachment;filename='.$gifFileName );
	$fn=fopen("plotPresets/".$gifFileName,"r"); 
	fpassthru($fn);
	fclose($fn);
} */
?>