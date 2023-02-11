<?php

$redis = new Redis();
$connected = $redis->connect('127.0.0.1', 6379);

if (!$connected) {
    echo "Error connecting to Redis\n";
    exit(1);
}

$redis->select(0);

$result = $redis->flushDB();

if ($result) {
    echo "Redis database flushed successfully\n";
} else {
    echo "Error flushing Redis database\n";
    exit(1);
}

?>