<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd"> 
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="refresh" content="300" >
<meta name="viewport" content="initial-scale=1, maximum-scale=1">
<style type="text/css">
body {
    font-family: Arial, Helvetica, sans-serif; }
#lcdDiv {
    float: left; }
#dataDiv {
    float: left;
    margin-left: 1em;
    font-weight: bold; }
#graphs {
    clear: both; }
button.largeBtn {
    width: 595px;
    height: 2em;
    max-width: 100%;
    font-size: 120%;
    font-weight: bold; }
img.graphImg {
    max-width: 100%;
    margin-top: 1em; }
</style>
<title>ProtTherm</title>
<script type="text/javascript" language="JavaScript">

function pageLoad() {
    document.getElementById("changeMode").disabled = false;
};

function changeMode() {
    document.getElementById("changeMode").disabled = true;
    document.body.style.cursor = 'wait';
    var request = new XMLHttpRequest();
    request.open("GET", "changemode.php", true);
    request.send();
    // Allow some time for stats data to be updated.
    setTimeout(function() {
        location.reload();
        document.body.style.cursor = 'auto';
    }, 6000);
};

</script>
</head>
<body onLoad="pageLoad();">
<h1>ProTherm</h1>
<div id="lcdDiv">
<img alt="LCD image" src="img/lcd_image.php"><p>
</div>
<div id="dataDiv">
<?php

$stats = '/run/shm/protherm/stats';
$data = NULL;
if ($f = fopen($stats, 'r')) {
    $line = fgets($f);
    fclose($f);
    // 1454593704 NTP_OK wlan0 192.168.10.193 100 PROG1 18250 14000 0
    $data = explode(' ' , $line);
    if (count($data) < 9) $data = NULL;
}

if ($data != NULL) {
    $prog   = $data[5];
    $temp   = (float)$data[6] / 1000;
    $tprog  = (float)$data[7] / 1000;
    $switch = (int)$data[8];
}

print htmlentities(sprintf("%.1f °C", $temp)) . '<br>';
if (substr($prog, 0, 6) == 'MANUAL') {
    print htmlentities(str_replace('_', ' ', $prog)) . '<br>';
} else {
    print htmlentities(sprintf("%s => %.1f °C", $prog, $tprog)) . '<br>';
}
print htmlentities(sprintf("Switch: %s", (($switch == 1) ? 'ON' : 'OFF'))) . '<br>';

?>
</div>

<div id="graphs">
<button class="largeBtn" type="button" id="changeMode" name="changeMode" onClick="changeMode()">Change program</button><br>
<p>
<button class="largeBtn" type="button" id="changeMode" name="changeMode" onClick="location.href='programs.php'">View Weekly Programs</button><br>
<img class="graphImg" alt="Daily graph" src="img/protherm-day.png"><br>
<img class="graphImg" alt="Weekly graph" src="img/protherm-week.png"><br>
<img class="graphImg" alt="Monthly graph" src="img/protherm-month.png"><br>
</div>

</body>
</html>
