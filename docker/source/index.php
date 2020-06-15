<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8">
		<meta name="generator" content="Docker Image: tobi312/alpine-nginx-php">
		<title>Site</title>
		<!--<link rel="stylesheet" href="style.css">-->
	</head>
	<body>
		<h1>Hello!</h1>
		<p>
			This is a simple website.<br>
			<?php
				echo date("Y-m-d H:i:s");
			?>
		</p>
	</body>
</html>