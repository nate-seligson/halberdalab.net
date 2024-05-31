<?php 
	$gifFileName = "number_sense_math_decile_animation.gif";
	if(file_exists($gifFileName)) {
		header ( 'Content-type:image/gif' );
		header ( 'Content-disposition:attachment;filename=number_sense_math_decile_animation.gif' );
		$fn=fopen($gifFileName,"r"); 
		fpassthru($fn);
		fclose($fn);
	} else {
		echo "not found";
	}
?>