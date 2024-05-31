<?php

	function endsWith($haystack, $needle) {
		$length = strlen($needle);
		$start  = $length * -1; //negative
		return (substr($haystack, $start) === $needle);
	}

  // adapted from comments in http://php.net/manual/en/function.readdir.php

  /**
   * Return the non-empty files (non-recursive) that reside under a directory.
   *
   * @return array
   * @param    string (required)   The directory you want to start in
   */ 

	function get_files($dir, $ext, $zeroOnly = FALSE) {
		$arr = array();
		if(is_dir($dir)) {
			if($dh = opendir($dir)) {
				while(($file = readdir($dh)) !== false) {
					if($file != "." && $file != ".." && !is_dir($dir."/".$file) && endsWith($file,$ext)) {
						if ((!$zeroOnly && filesize($file) > 0) || ($zeroOnly && filesize($file) == 0)) {
							$arr[] = $dir."/".$file; 
						}
					}
				}
				closedir($dh);
			}
		}
		return $arr;
	}
?>

<?php
set_time_limit(0);
$f = fopen("convert.log", "a");
fwrite($f, "[".date(r) . "] " . PHP_EOL);
if (strtoupper(substr(PHP_OS, 0, 3)) === 'WIN') {
	$command = "..\convert.exe";
} elseif(PHP_OS === "Linux") {
	$command = "/usr/bin/convert";
} else {
	fwrite($f, "could not determine OS" . PHP_EOL);
	exit();
}

if(isset($_POST['imageData']) && isset($_POST['fileID']) ) {
	try {
		$gifFileName = 'animation'.$_POST['fileID'].'.gif';
		$images = explode(",", $_POST['imageData']);
		$sliderDeltaX = ($_POST['delay'] == "10" ? 5.113 : 5.113*.33);
		//$sliderDeltaX = 1.0197; //DEV: decile
		if (isset($_POST['chainId'])) {
			$folderName = 'img'.$_POST['chainId'].'Output'.$_POST['fileID'];
		} else {
			$folderName = 'img'.rand(0,999).'Output'.$_POST['fileID'];
		}
		$offset = 0;
		if (isset($_POST['offset'])) {
			$offset = $_POST['offset'];
		}
		mkdir($folderName.'/');
		fwrite($f, count($images) . ' incoming frames, file id: ' . $gifFileName . ', folder name: ' . $folderName . PHP_EOL);
		
		// create slider invariant base once
		$imgSliderBase = imagecreatetruecolor(620, 100);
		$white = imagecolorallocate($imgSliderBase, 255, 255, 255); //slider ticks and text
		$lightblack = imagecolorallocate($imgSliderBase, 26, 26, 26); //background
		imagefilledrectangle($imgSliderBase, 0, 0, 620, 100, $lightblack);
		
		$xpad = 78;
		$ypad = 5;
		imagerectangle($imgSliderBase, $xpad+10, $ypad+15, $xpad+373, $ypad+25, $white);
		
		$ypad = 8;
		for($j = 0; $j < 8; $j++) {
			imageline($imgSliderBase, ($xpad+10)+($j*51.13), $ypad+35, ($xpad+10)+($j*51.13), $ypad+40, $white);
			imagettftext($imgSliderBase, 10, 0, ($xpad+3)+($j*51.13), $ypad+53, $white, 'arial.ttf', (10*$j)+10);
		}
		imagettftext($imgSliderBase, 11, 0, ($xpad+10)+(373/2)-45, $ypad+74, $white, 'arial.ttf', 'Age (years)');
		
		for($i = $offset; $i < ($offset+count($images)); $i++) {
			//import graph
			$imgGraph = imagecreatefromstring(base64_decode($images[$i-$offset]));
			
			//create composite image and copy in graph + slider
			/* PROD */
			$imgComposite = imagecreatetruecolor(620, 550); //height = graph height + sliderbar img height
			imagefilledrectangle($imgComposite, 0, 0, 620, 550, $lightblack); //fill background with 90% black
			imagecopy($imgComposite, $imgGraph, 0, 5, 0, 0, 620, 450);
			imagecopy($imgComposite, $imgSliderBase, 0, 455, 0, 0, 620, 100);
			
			// draw slider peg
			$green = imagecolorallocate($imgComposite, 69, 158, 0); //slider peg
			$ypad = 5+455;
			imagefilledrectangle($imgComposite, $xpad+8+($i*$sliderDeltaX), $ypad+7, $xpad+12+($i*$sliderDeltaX), $ypad+33, $green);
			
			/* DEV - for presets: scatter graph only cropped version
			$imgComposite = imagecreatetruecolor(620, 450); //height = graph height only
			imagefilledrectangle($imgComposite, 0, 0, 620, 450, $lightblack); //fill background with 90% black
			imagecopy($imgComposite, $imgGraph, 0, 0, 0, 0, 620, 450);
			*/
			
			/* DEV - decile conversion
			$imgComposite = imagecreatetruecolor(540, 550);
			imagefilledrectangle($imgComposite, 0, 0, 540, 550, $lightblack); //fill background with 90% black
			imagecopy($imgComposite, $imgGraph, 0, 0, 0, 0, 540, 550);
			imagecopy($imgComposite, $imgSlider, 0, 450, 27, 0, 540, 100);
			 */
			// END
			$filename = $folderName . '/' . str_pad($i, 3, "0", STR_PAD_LEFT);
			imagepng($imgComposite, $filename . '.png');
			// if you write straight to gif, file sizes are larger...
			//imagegif($imgComposite, $filename . '.gif');
			
			imagedestroy($imgGraph);
			imagedestroy($imgComposite);
			
			$results = shell_exec($command.' '.$filename.'.png '.$filename.'.gif');
			if($results) { fwrite($f, $results . PHP_EOL); }
		}
		imagedestroy($imgSliderBase);
		
		chdir($folderName);
		/*
		$dirArray = get_files(".", ".png");
		
		$numFrames = count($dirArray);
		fwrite($f, "looping through " . $numFrames . " files" . PHP_EOL);
		
		for($i = 0; $i < $numFrames; $i++) {
			$filename = basename($dirArray[$i], ".png");
			//fwrite($f, $filename . PHP_EOL);
			$results = shell_exec($command.' '.$filename.'.png '.$filename.'.gif');
			if($results) { fwrite($f, $results . PHP_EOL); }
		}
		*/
		fwrite($f, "breakpoint3 - done first pass of gif conversion" . PHP_EOL);
		$dirArrayZero = get_files(".", ".gif", TRUE);
		
		$tries = 0;
		do {
			fwrite($f, "bad count: " . count($dirArrayZero) . PHP_EOL);
			for($i = 0; $i < count($dirArrayZero); $i++) {
				$filename = basename($dirArrayZero[$i], ".gif");
				fwrite($f, "redoing #" . $filename . PHP_EOL);
				//shell_exec('rm '.$filename.'.gif');
				//shell_exec('mv '.$filename.'.png a.png');
				$results = shell_exec($command.' '.$filename.'.png '.$filename.'.gif');
				//$results = shell_exec($command.' a.png '.$filename.'.gif');
				if($results) { fwrite($f, $results . PHP_EOL); }
			}
			$dirArrayZero = get_files(".", TRUE);
			$tries++;
			fwrite($f, "fix gif conversion try #" . $tries . " complete" . PHP_EOL);
		} while (count($dirArrayZero) > 0 && $tries < 5);
		
		fwrite($f, "breakpoint4 - done attempted fixes on gif conversion" . PHP_EOL);
		if(!isset($_POST['skipGif'])) {
			$results = shell_exec($command.' -loop 0 -limit memory 16MiB -limit map 16MiB -delay '. $_POST['delay'] .' *.gif '.$gifFileName);
			if($results) { fwrite($f, $results . PHP_EOL); }
			fwrite($f, "breakpoint5 - created animated gif" . PHP_EOL);
			copy($gifFileName, "../plotPresets/".$gifFileName);
		} else {
			fwrite($f, "breakpoint6 - skipping animated gif creation" . PHP_EOL);
		}
		
		echo('complete');
	} catch (Exception $e) {
		fwrite($f, $e->getMessage() . PHP_EOL);
	}
}
fwrite($f, "end: [". date(r) . "] " . PHP_EOL);
fclose($f);
?>