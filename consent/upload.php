<html>
<head>
<title>Debriefing Upload</title>
</head>
<body>
<?php
if(isset($_POST['submit'])){
    $name = $_POST['name'];
    $title = $_POST['title'];
    $content = $_POST['content'];
    $sep1 = "\n******";
    $sep2 = "\n------\n";

    $debrief = "\n" . $name . ' - ' . $title . $sep2 . $content . $sep1;

    $all_filename = "debriefs/all.txt";

    $ind_filepath = "debriefs/" .
         strtolower(str_replace(' ','_',$name).'-'.str_replace(' ','_',$title)) . '.txt';

    $f_ind = fopen($ind_filepath,'w') or die("Unable to open file " . $ind_filepath);
    fwrite($f_ind,$debrief);
    fclose($f_ind);

    $f_all = fopen($all_filename,"a") or die("Unable to open " . $all_outpath);
    fwrite($f_all,$debrief);
    fclose($f_all);
    echo '<script type="text/javascript">alert("Success!");</script>';
}
?>
<h1>Debriefing Upload</h1>
Email visionlabjhu@gmail.com with problems in this upload process.
<br>
<br>
<form method="post" action="">
Your Name (full name please):
<br>
<input type="text" size="30" maxlength="100" name="name">
<br />
<br />
Title of Debriefing Form:
<br/>
<input type="text" size="30" maxlength="3000" name="title">
<br/> 
<br/>
Debriefing text (3000 max characters):
<br/>
<textarea rows="20" cols="60" name="content" wrap="physical"></textarea><br />
<br>
<input type="submit" value="Submit" name="submit">
</form>
</body>
</html>

