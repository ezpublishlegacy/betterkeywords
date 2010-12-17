<?php

header('HTTP/1.0 200 OK');

$file = fopen("./extension/betterkeywords/store/betterkeywords.txt", "w");

fwrite($file, $_POST['betterkeywords']);

echo  `cat ./extension/betterkeywords/store/betterkeywords.txt`;

eZExecution::cleanExit();

?>
