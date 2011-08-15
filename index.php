#!/xhbin/php
<?php

function display_form() {
	global $bldg, $dow, $dur, $start;
	echo "<form method=\"POST\" action=\"", $_SERVER['PHP_SELF'], "\">\n";

	##### Building #####
	$buildings = array("AL", "ARC", "B1", "B2", "BMH", "C2", "CGC", "CPH", "DC", "DWE", "E2", "ECH", "EIT", "ESC", "EV1", "EV2", "HH", "LIB", "MC", "ML", "OPT", "PAS", "PHY", "RCH", "STJ", "STP");
	echo "Building:\n	<select name=\"bldg\">\n";
	foreach ($buildings as $x) {
		$selected = ($x === $bldg ? "selected" : "");
		echo "		<option value=\"$x\" $selected>$x</option>\n";
	}
	echo "</select>\n";

	##### Day of Week #####
	$days = array("M"=>"Mon", "T"=>"Tue", "W"=>"Wed", "H"=>"Thu", "F"=>"Fri");
	echo "&nbsp;&nbsp;Day of week:\n	<select name=\"dow\">\n";
	foreach ($days as $k => $v) {
		$selected = ($k === $dow ? "selected" : "");
		echo "	<option value=\"$k\" $selected>$v</option>\n";
	}
	echo "</select>\n";

	##### Start time #####
	echo "&nbsp;&nbsp;Start time:\n	<select name=\"start\">\n";
	for ($hour = 8; $hour <= 23; $hour += 1) {
		for ($min = 0; $min <= 30; $min += 30) {
			$hour_str = ($hour < 10 ? "0$hour" : "$hour");
			$min_str = ($min < 10 ? "0$min" : "$min");
			$selected = ($start === "$hour_str$min_str" ? "selected" : "");
			echo "		<option value=\"$hour_str$min_str\" $selected>$hour_str:$min_str</option>\n";
		}
	}
	echo "	</select>\n";

	##### Duration #####
	echo "&nbsp;&nbsp;Duration:\n	<select name=\"dur\">\n";
	for ($i = 1; $i <= 5; $i += 1) {
		$selected = ($i == $dur ? "selected" : "");
		echo "		<option value=\"$i\" $selected>$i</option>\n";
	}
	echo "	</select>&nbsp;&nbsp;hours<br/><br/>\n";

	echo "\n	<input type=\"hidden\" name=\"_submitted\" value=\"1\"/>\n";
	echo "	<input type=\"submit\" value=\"Search!\"/>\n</form>\n";
}

$bldg = "MC";
$dow = $dur = "";
$start = "1030";

echo "<html>\n<title>OpenRoom</title>\n<body>\n";
echo "  <div style=\"font-size: 20pt\"><b><a href=\"index.php\">OpenRoom</a></b></div>\n";
echo "  <div style=\"text-align:left; font-size: 8pt\" ><u>(Under)<a href=\"src\">Powered by</a> MzScheme</u></div><br/>\n";

if (array_key_exists('_submitted', $_POST)) {
	$bldg = $_POST['bldg'];
	$dow = $_POST['dow'];
	$start = $_POST['start'];
	$dur = $_POST['dur'];
	$end = $dur * 100 + $start;

	display_form();

	echo "<hr color=\"#000000\">";
	echo "Available rooms:<br/>\n";
	echo "<pre>\n";
	system("./src/openroom.sh ".escapeshellarg($bldg)." ".escapeshellarg($dow)." ".escapeshellarg($start)." ".escapeshellarg($end)." 2>&1", $rc);
	echo "\n</pre>\n";
} else {
	display_form();
}

echo "</body>\n</html>\n";
?>
