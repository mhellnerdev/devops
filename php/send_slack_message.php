<?php

// To use the below, you must capture the output of a stored variale and pipe it into here from
// another php script.  The following line must exists in what script is piping output to this script.
// fwrite(STDOUT, $alert);
// cli usage: php alert.php | php send_messsage.php
$alert = trim(fgets(STDIN));

function send_slack_message($message)
{
    $slack_webhook_url = "<WEBHOOK_URL>";
    $emoji = ":rotating_light:";

    $data = array(
        "text"          =>  $message,
        "icon_emoji"    =>  $emoji,
    );

    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $slack_webhook_url);
    curl_setopt($ch, CURLOPT_CUSTOMREQUEST, "POST");
    curl_setopt($ch, CURLOPT_POSTFIELDS, "payload=" . json_encode($data));
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
    $result = curl_exec($ch);
    curl_close($ch);

    return $result;
}

$message = "Your alert: $alert";


send_slack_message($message);
