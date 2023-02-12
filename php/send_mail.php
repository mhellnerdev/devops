<?php

// To use the below, you must capture the output of a stored variable and pipe it into here from
// another php script.  The following line must exists in what script is piping output to this script.
// fwrite(STDOUT, $subject);
// fwrite(STDOUT, $alert);
// cli usage: php alert.php | php send_mail.php
// this will allow you to pass an email address to send to
// cli usage php alert.php | php send_mail.php mhellner@circlelabs.sh

$to = (isset($argv[1])) ? $argv[1] : "noreply@circlelabs.sh";
$alert = '$alert from sendmail.php';
$headers = "From: noreply@circlelabs.sh\r\n";
$subject = trim(fgets(STDIN));
$alert = trim(fgets(STDIN));

mail($to, $subject, $alert, $headers);

echo "Email sent successfully.\n";
