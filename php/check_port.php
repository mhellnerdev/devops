<?php

$host = "127.0.0.1";
$port = 80;
$service = "httpd";

$output = shell_exec("nc -vz $host $port; echo $?");

if (trim($output) == "1") {
    echo "Port $port is refused. Restarting $service...\n";
    shell_exec("sudo systemctl restart $service");
} else {
    echo "Port $port is open. No action required.\n";
}

?>