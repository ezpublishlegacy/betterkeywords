<?php

header('HTTP/1.0 200 OK');
header('Content-type: text/plain');

$file =  file_get_contents('./extension/betterkeywords/store/betterkeywords.txt');

if ($file) {
	$dirtygroups = explode("\n\n", $file);
	$cleangroups = array();

	foreach ($dirtygroups as $category => $group) {
		$group = explode("\n", $group);
		foreach ($group as &$keyword) {
			$keyword = preg_replace('/,/', '', $keyword);
		}
		$cleangroups[preg_replace('/\[(.*)\]/', '$1', $group[0])] = array_slice($group, 1);
	}

	$json_array['categories'] = $cleangroups;

	echo json_encode($json_array);
} else {
	echo 'empty or unreadable file';
}

eZExecution::cleanExit();

?>
