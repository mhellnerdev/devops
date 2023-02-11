<?php

// This sctipt will pipe what gets stored as an alert to STDOUT
// Using the standard | pipe command in bash will allow for you to use this
// script to a second script that must contain the following code to capture
// the variable. The second scripts behavior will be to send an alert of some kind.
// Add the below commented line to the script that sends the message. 
// This can help build the payload of the message.
//
// $alert = trim(fgets(STDIN));
//
// cli usage: php alert.php | php send_messsage.php

$alert = "Hello from message script!";

fwrite(STDOUT, $alert);
