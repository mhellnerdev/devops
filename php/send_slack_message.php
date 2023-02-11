<?php

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

$message = "This is a log alert from PHP script.";

send_slack_message($message);
