<?php
chdir("generatePreset1");
$cwd = opendir(".");
$dirArray = array();
while($entryName = readdir($cwd)) {
	if (substr($entryName, -4) == ".png") {
		$dirArray[] = $entryName;
	}
}
closedir($cwd);

$f = fopen("../data.preset1.js", "w");
fwrite($f, "var preset1 = [".PHP_EOL);
for($i = 0; $i < count($dirArray); $i++) {

	$imgbinary = fread(fopen($dirArray[$i], "r"), filesize($dirArray[$i]));
	fwrite($f, "'data:image/png;base64," . base64_encode($imgbinary) ."',".PHP_EOL);
}
fwrite($f, "];".PHP_EOL.PHP_EOL);

chdir("../generatePreset1Ovals");
$cwd = opendir(".");
$dirArray = array();
while($entryName = readdir($cwd)) {
	if (substr($entryName, -4) == ".png") {
		$dirArray[] = $entryName;
	}
}
closedir($cwd);

fwrite($f, "var ovalpreset1 = [".PHP_EOL);
for($i = 0; $i < count($dirArray); $i++) {

	$imgbinary = fread(fopen($dirArray[$i], "r"), filesize($dirArray[$i]));
	fwrite($f, "'data:image/png;base64," . base64_encode($imgbinary) ."',".PHP_EOL);
}
fwrite($f, "];".PHP_EOL);

fclose($f);
?>