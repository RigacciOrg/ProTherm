<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta name="viewport" content="initial-scale=1, maximum-scale=1">
<style type="text/css">
body {
    font-family: Arial, Helvetica, sans-serif; }
img.graphImg {
    max-width: 100%;
    margin-top: 1em;
    border: 1px solid #c0c0c0;}
</style>
<title>ProtTherm Weekly Programs</title>
</head>
<body>
<h1>ProTherm Weekly Programs</h1>

<?php

$LIB_DIR = '/usr/local/lib/protherm';

$progs = array();
if (is_dir($LIB_DIR)) {
    if ($dh = opendir($LIB_DIR)) {
        while (($file = readdir($dh)) !== false) {
            $f = $LIB_DIR . DIRECTORY_SEPARATOR . $file;
            if (filetype($f) == 'file' and substr($file, 0, 4) == 'PROG' and substr($file, -4) == '.txt') {
                array_push($progs, $file);
            }
        }
        closedir($dh);
    }
}

sort($progs);
foreach($progs as $file) {
    echo '<img class="graphImg" src="prog_graph.php?p=' . htmlentities(urlencode($file));
    echo '" alt="' . htmlentities($file) . '">' . "\n";
    echo "<p>\n";
}
?>
</body>
</html>
