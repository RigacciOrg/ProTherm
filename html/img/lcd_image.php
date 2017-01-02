<?php

$image = new Imagick();
$image->readImage('/run/shm/protherm/lcd.png');
$image->BorderImage(new ImagickPixel('white'), 4, 4);
$image->opaquePaintImage('white', '#a4b59a', 20, False);
$image->opaquePaintImage('black', '#2d3452', 20, False);
$image->scaleImage(168, 0);

header("Content-Type: image/" . $image->getImageFormat());
echo $image;
