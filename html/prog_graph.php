<?php

//--------------------------------------------------------------
//--------------------------------------------------------------

$WIDTH = 1600;
$HEIGHT = 400;

$MARGIN_TOP    = (int)($HEIGHT * 0.12);         // Margins between image borders and graph.
$MARGIN_BOTTOM = (int)($HEIGHT * 0.20);
$MARGIN_LEFT   = (int)($WIDTH  * 0.05);
$MARGIN_RIGHT  = (int)($WIDTH  * 0.03);
$XTICS_WIDTH   = (int)($HEIGHT * 0.0240);
$YTICS_WIDTH   = (int)($WIDTH  * 0.0035);
$LABEL_MARGIN  = 0.8;                           // Margin between image borders and title/legends.

$Y_MIN = 12.0;
$Y_MAX = 23.0;
$Y_AUTORANGE = TRUE;
$Y_TICS_STEP = 1.0;

$X_MIN = 0;
$X_MAX = 60 * 60 * 24 * 7;   // One week (in seconds).
$X_TICS_STEP = 60 * 60 * 24; // 24 hours step.
$X_MTICS_STEP = 60 * 60 * 6; // 6 hours step.

$tics_font = 'fonts/arial.ttf';
$label_font = 'fonts/arial.ttf';
$label_font_bold = 'fonts/arialbd.ttf';
$tics_font_size = 11;
$label_font_size = 14;

$LIB_DIR = '/usr/local/lib/protherm';

//--------------------------------------------------------------
// Define styles.
//--------------------------------------------------------------
$im = imagecreatetruecolor($WIDTH, $HEIGHT);

$bground_color = imagecolorallocate($im, 255, 255, 255);
$outline_color = imagecolorallocate($im, 151, 42, 0);
$fill_color    = imagecolorallocate($im, 255, 71, 0);
$stroke_solid  = imagecolorallocate($im, 0, 0, 0);
$stroke_light  = imagecolorallocate($im, 160, 160, 160);
$style_dashed  = array($stroke_light, $stroke_light, IMG_COLOR_TRANSPARENT, IMG_COLOR_TRANSPARENT, IMG_COLOR_TRANSPARENT);

imagefill($im, 0, 0, $bground_color);
imagesetstyle($im, $style_dashed);

//--------------------------------------------------------------
// Convert a string "w HH:MM" (day of week with time) into Unix
// timestamp. String "0 00:00" is monday 1970-01-05 at 00:00.
//--------------------------------------------------------------
function week_time($string) {
    $week_time = NULL;
    if (preg_match('/^(\d) (\d\d):(\d\d)$/', $string, $m)) {
        $week_day = (int)$m[1];
        $hour     = (int)$m[2];
        $minute   = (int)$m[3];
        if ($week_day >= 0 and $week_day <=  6 and
            $hour     >= 0 and $hour     <= 23 and
            $minute   >= 0 and $minute   <= 59) {
            // 1970-01-05 is monday
            $day = 5 + $week_day;
            $week_time = mktime($hour, $minute, 0, 1, $day, 1970);
        }
    }
    return $week_time;
}

//--------------------------------------------------------------
// Read programmed temperatures from file.
//--------------------------------------------------------------
function read_program($filename) {
    global $Y_MIN, $Y_MAX, $Y_AUTORANGE;
    $program_points = array();
    $min_value = NULL;
    $max_value = NULL;
    $handle = @fopen($filename, 'r');
    if ($handle) {
        while (($buffer = fgets($handle, 1024)) !== FALSE) {
            $buffer = trim($buffer);
            if (preg_match('/^(\d \d\d:\d\d)\s+(\d+(\.\d+)?)$/', $buffer, $m)) {
                $key = $m[1];
                $val = (float)($m[2]);
                if (week_time($key) != NULL) {
                    if ($min_value == NULL or $min_value > $val) $min_value = $val;
                    if ($max_value == NULL or $max_value < $val) $max_value = $val;
                    $program_points[$key] = $val;
                }
            }
        }
        fclose($handle);
    }
    // If value for first day time 00:00 is missing, add a fake one.
    if (count($program_points) > 0) {
        ksort($program_points);
        reset($program_points);
        $first_key = key($program_points);
        if ($first_key != '0 00:00') {
            $program_points['0 00:00'] = NULL;
            ksort($program_points);
        }
    }
    if ($Y_AUTORANGE) {
        if ($min_value != NULL) $Y_MIN = (int)($min_value - 3.0);
        if ($max_value != NULL) $Y_MAX = (int)($max_value + 2.0);
        //error_log('Range: ' . $Y_MIN . ', ' . $Y_MAX);
    }
    //error_log('$program_points: ' . print_r($program_points, TRUE));
    return $program_points;
}

//--------------------------------------------------------------
// Main program
//--------------------------------------------------------------
$program_file = basename($_REQUEST['p']);
$fp = $LIB_DIR . DIRECTORY_SEPARATOR . $program_file;
$program_points = read_program($fp);
$y_px = ($HEIGHT - $MARGIN_TOP  - $MARGIN_BOTTOM) / ($Y_MAX - $Y_MIN);
$x_px = ($WIDTH  - $MARGIN_LEFT - $MARGIN_RIGHT)  / ($X_MAX - $X_MIN);

//---------------------------------------------------------------
// Plot the graph data.
//---------------------------------------------------------------

// Build a polygon with programmed temperature points.
$points = array();
$fill_point = NULL;
// Start at lower left corner.
$points[] = $MARGIN_LEFT;
$points[] = $HEIGHT - $MARGIN_BOTTOM;
$prev_y = $HEIGHT - $MARGIN_BOTTOM;
foreach ($program_points as $time_str => $temp) {
    $x = $MARGIN_LEFT + (int)((week_time($time_str) - week_time('0 00:00')) * $x_px);
    if ($temp == NULL) $temp = $Y_MIN;
    $y = ($HEIGHT - $MARGIN_BOTTOM) - (int)(($temp - $Y_MIN) * $y_px);
    // Draw a step, no linear interpolation.
    $points[] = $x;
    $points[] = $prev_y;
    $points[] = $x;
    $points[] = $y;
    $prev_y = $y;
    if ($fill_point == NULL and $y < ($HEIGHT - $MARGIN_BOTTOM - 1) and $x < ($WIDTH - $MARGIN_RIGHT - 1)) {
        $fill_point = $x + 1;
    }
}
// Extend the polygon to the right edge.
$points[] = $WIDTH - $MARGIN_RIGHT;
$points[] = $prev_y;
// Complete the polygon drawing: lower right and lower left corners.
$points[] = $WIDTH - $MARGIN_RIGHT;
$points[] = $HEIGHT - $MARGIN_BOTTOM;
$points[] = $MARGIN_LEFT;
$points[] = $HEIGHT - $MARGIN_BOTTOM;

// Plot the graph data and fill it.
imagepolygon($im, $points, count($points) / 2, $outline_color);
if ($fill_point != NULL) {
    imagefill($im , $fill_point, $HEIGHT - $MARGIN_BOTTOM - 1, $fill_color);
}

//---------------------------------------------------------------
// Draw other elements.
//---------------------------------------------------------------

// YTics
for ($y_val = $Y_MIN; $y_val <= $Y_MAX; $y_val += $Y_TICS_STEP) {
    $y = (int)(($HEIGHT - $MARGIN_BOTTOM) - (($y_val - $Y_MIN) * $y_px));
    $ret = imageline($im, $MARGIN_LEFT - $YTICS_WIDTH, $y, $MARGIN_LEFT, $y, $stroke_solid);
    $ret = imageline($im, $MARGIN_LEFT, $y, $WIDTH - $MARGIN_RIGHT, $y, IMG_COLOR_STYLED);
    $ret = imageline($im, $WIDTH - $MARGIN_RIGHT, $y, $WIDTH - $MARGIN_RIGHT + $YTICS_WIDTH, $y, $stroke_solid);
    $label = sprintf('%d', $y_val);
    $bbox = imagettfbbox($tics_font_size, 0, $tics_font, $label);
    imagettftext($im, $tics_font_size, 0, $MARGIN_LEFT - ($YTICS_WIDTH * 1.5) - abs($bbox[4]), $y + (int)(abs($bbox[5]) /2 ), $stroke_solid, $tics_font, $label);
}

// XTics
$offset = (60 * 60 * 12);
for ($x_val = $X_MIN + $offset; $x_val <= $X_MAX; $x_val += $X_TICS_STEP) {
    $x = $MARGIN_LEFT + $x_val * $x_px;
    $ret = imageline($im, $x, $MARGIN_TOP - $XTICS_WIDTH, $x, $MARGIN_TOP, $stroke_solid);
    $ret = imageline($im, $x, $MARGIN_TOP, $x, $HEIGHT - $MARGIN_BOTTOM, IMG_COLOR_STYLED);
    $ret = imageline($im, $x, $HEIGHT - $MARGIN_BOTTOM + $XTICS_WIDTH, $x, $HEIGHT - $MARGIN_BOTTOM, $stroke_solid);
    // 1970-01-05 is monday.
    $timestamp = mktime(0, 0, 0, 1, 5, 1970) + $x_val;
    $label = date("H:i\nD", $timestamp);
    $bbox = imagettfbbox($tics_font_size, 0, $tics_font, $label);
    imagettftext($im, $tics_font_size, 0, $x - (int)(abs($bbox[4]) / 2), $HEIGHT - $MARGIN_BOTTOM + ($XTICS_WIDTH * 1.5) + abs($bbox[5]), $stroke_solid, $tics_font, $label);
}

// XmTics
for ($x_val = $X_MIN; $x_val <= $X_MAX; $x_val += $X_MTICS_STEP) {
    if ((($x_val + $offset) % $X_TICS_STEP) == 0) continue;
    $x = $MARGIN_LEFT + $x_val * $x_px;
    $ret = imageline($im, $x, $MARGIN_TOP - (int)($XTICS_WIDTH / 2), $x, $MARGIN_TOP, $stroke_solid);
    $ret = imageline($im, $x, $MARGIN_TOP, $x, $HEIGHT - $MARGIN_BOTTOM, IMG_COLOR_STYLED);
    $ret = imageline($im, $x, $HEIGHT - $MARGIN_BOTTOM + (int)($XTICS_WIDTH / 2), $x, $HEIGHT - $MARGIN_BOTTOM, $stroke_solid);
    // 1970-01-05 is monday.
    $timestamp = mktime(0, 0, 0, 1, 5, 1970) + $x_val;
    $label = date("H:i", $timestamp);
    $bbox = imagettfbbox($tics_font_size, 0, $tics_font, $label);
    imagettftext($im, $tics_font_size, 0, $x - (int)(abs($bbox[4]) / 2), $HEIGHT - $MARGIN_BOTTOM + ($XTICS_WIDTH * 1.5) + abs($bbox[5]), $stroke_solid, $tics_font, $label);
}

// Borders
$ret = imageline($im, $MARGIN_LEFT, $MARGIN_TOP, $WIDTH - $MARGIN_RIGHT, $MARGIN_TOP, $stroke_solid);
$ret = imageline($im, $WIDTH - $MARGIN_RIGHT, $MARGIN_TOP, $WIDTH - $MARGIN_RIGHT, $HEIGHT - $MARGIN_BOTTOM, $stroke_solid);
$ret = imageline($im, $WIDTH - $MARGIN_RIGHT, $HEIGHT - $MARGIN_BOTTOM, $MARGIN_LEFT, $HEIGHT - $MARGIN_BOTTOM, $stroke_solid);
$ret = imageline($im, $MARGIN_LEFT, $HEIGHT - $MARGIN_BOTTOM, $MARGIN_LEFT, $MARGIN_TOP, $stroke_solid);

// Title
$label = 'Temperature Program ' . $program_file;
$bbox = imagettfbbox($label_font_size, 0, $label_font_bold, $label);
imagettftext($im, $label_font_size, 0, (int)(($WIDTH - abs($bbox[4])) / 2), (int)(abs($bbox[5]) * (1 + $LABEL_MARGIN)) , $stroke_solid, $label_font_bold, $label);

// X Legend
$label = 'Orario';
$bbox = imagettfbbox($label_font_size, 0, $label_font_bold, $label);
imagettftext($im, $label_font_size, 0, (int)(($WIDTH - abs($bbox[4])) / 2), (int)($HEIGHT - abs($bbox[5]) * $LABEL_MARGIN) , $stroke_solid, $label_font_bold, $label);

// Y Legent
$label = '°C';
$bbox = imagettfbbox($label_font_size, 90, $label_font_bold, $label);
imagettftext($im, $label_font_size, 90, (int)(abs($bbox[4]) * (1 + $LABEL_MARGIN)), (int)(($HEIGHT + abs($bbox[5])) / 2) , $stroke_solid, $label_font_bold, $label);

header('Content-Type: image/png');

imagepng($im);
imagedestroy($im);

?>
