<?php
//maker and getter file for Turk experimental assignments
//called when the page loads to get the experimental condition from a file on the langcog server
//or to create such a file if it doesn't exist yet.

#sample query string
#if:
#conds= unstructured-12,12;1515-12,12;2424-12,12;3333-12,12
#filename= sm_unstructured_13jan
#then the query string looks like:
#?conds=unstructured-12,12;1515-12,12;2424-12,12;3333-12,12&filename=sm_unstructured_13jan

header('Access-Control-Allow-Origin: *');
if (isset($_GET['conds'])) {
	$conds_string = $_GET['conds'];
	$conds = explode( ",", $conds_string );

	#$directory = "experiment_files/conds_files/";
	if (isset($_GET['dir'])) {
		$dir_string = $_GET['dir'];
	} else {
		$dir_string = 'condition_files';
	}
	$directory = $dir_string . "/";

	# try to make the directory
	mkdir($directory, 0777, true);

	// $conds = array(0,1,2,3,4,5);
	$filecount = array_fill(0, count($conds), 0);

	for($x = 0; $x < count($conds); $x++) {
		$conds_string = $conds[$x];
		$files = glob($directory . "*_" . $conds_string);
		if ($files) {
		 $filecount[$x] = count($files);
		}
	}
	$cond_array_keys = array_keys($filecount);
	// get random of the min values
	$min_array_items = array_keys($filecount, min($filecount),false);
	$rand_item = array_rand($min_array_items);
	echo $cond_array_keys[$min_array_items[$rand_item]];
}
else {
	echo "The necessary parameters are not set";
}
?>
