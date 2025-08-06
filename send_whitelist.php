<?php

// A simple script to email a Minecraft username for whitelisting.

// Only allow POST requests.
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
  // Redirect non-POST requests to the homepage.
  header('Location: /');
  exit;
}

// Sanitize the username input.
// htmlspecialchars is used to prevent XSS. trim removes whitespace.
$username = isset($_POST['minecraft_username']) ? htmlspecialchars(trim($_POST['minecraft_username']), ENT_QUOTES, 'UTF-8') : '';

if (empty($username)) {
  // Use a class for styling the error message.
  echo '<div class="feedback-error">❌ Please enter a valid username.</div>';
  exit;
}

// Email details
$to = 'me@aaronperkel.com';
$subject = 'Minecraft Whitelist Request';
$body = "Whitelist request:\n\nUsername: {$username}\n\nIP: {$_SERVER['REMOTE_ADDR']}";

// Set email headers.
$headers = [
  'From: no-reply@aaronperkel.com',
  'Reply-To: no-reply@aaronperkel.com',
  'X-Mailer: PHP/' . phpversion()
];

// The mail() function returns true if the email was accepted for delivery, false otherwise.
// Note: For this to work, the server needs a configured mail server (like sendmail or postfix).
$isSent = mail($to, $subject, $body, implode("\r\n", $headers));

if ($isSent) {
  // Use a class for styling the success message.
  echo '<div class="feedback-success">✅ Request sent! I’ll add you ASAP.</div>';
} else {
  // Use a class for styling the error message.
  echo '<div class="feedback-error">❌ Oops, something went wrong sending the email.</div>';
}
