<?php 
if(isset($_GET["ovals"]) && $_GET["ovals"]==1) {
	$gifFileName = "number_sense_math_full_scatter_ovals_animation.gif";
} else {
	$gifFileName = "number_sense_math_full_scatter_animation.gif";
}
if(file_exists($gifFileName)) {
	header ( 'Content-type:image/gif' );
	header ( 'Content-disposition:attachment;filename=' . $gifFileName );
	
	ob_clean();
	flush();
	readfile($gifFileName);
} else {
	echo "not found";
}
?>