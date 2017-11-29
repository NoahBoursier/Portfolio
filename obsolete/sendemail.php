<?php

/* Subject and email variables */

$emailsSubject = 'Site Contact Form';
$webMaster  = 'noahboursier@gmail.com';


/* Gathering Data Variables - Whats in the form */

$name = $_POST ['name'];
$email = $_POST ['email'];
$subject = $_POST ['subject'];
$msg = $_POST['msg'];


/*Security*/


/* What You Want To See In The Email Place Inbetween $body = <<<EOD  and EOD; */    
$body = <<<EOD

<strong>Client:</strong> $name
<br />
<br />
<strong>Email:</strong> $email
<br />
<br />
<strong>Subject:</strong> $subject
<br />
<br />
______________________________________________
<br />
<br />
$msg

EOD;

/* Headers is a tag containing the users email and how you want it to display in your email */

$headers = "From: $email\r\n";
$headers .= "Content-type: text/html\r\n";

/* This is what sends the email */
$success = mail($webMaster, $emailsSubject, $body, $headers);

/* Results Rendered as Html */
echo file_get_contents("EmailSent.html");

?>