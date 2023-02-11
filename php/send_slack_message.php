<?php

function send_slack_message($message, $channel = "#general")
{
    $slack_webhook_url = "YOUR_SLACK_WEBHOOK_URL";

    $data = "payload=" . json_encode(array(
        "channel"       =>  $channel,
        "text"          =>  $message,
        "icon_emoji"    =>  ":rotating_light:"
    ));

    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $slack_webhook_url);
    curl_setopt($ch, CURLOPT_CUSTOMREQUEST, "POST");
    curl_setopt($ch, CURLOPT_POSTFIELDS, $data);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
    $result = curl_exec($ch);
    curl_close($ch);

    return $result;
}

$message = "This is a log alert from PHP script.";
$channel = "#alerts";

send_slack_message($message, $channel);
