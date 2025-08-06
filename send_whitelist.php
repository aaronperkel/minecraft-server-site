<?php
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
  header('Location: /');
  exit;
}

// sanitize
$username = trim(filter_input(INPUT_POST, 'minecraft_username', FILTER_SANITIZE_STRING));
if (!$username) {
  echo 'Please enter a valid username.';
  exit;
}

// build mail
$to = 'me@aaronperkel.com';
$subject = 'Minecraft Whitelist Request';
$body = "Whitelist request:\n\nUsername: {$username}\n\nIP: {$_SERVER['REMOTE_ADDR']}";
$headers = [
  'From' => 'no-reply@aaronperkel.com',
  'Reply-To' => 'no-reply@aaronperkel.com',
  'X-Mailer' => 'PHP/' . phpversion()
];

// send it
$ok = mail($to, $subject, $body, join("\r\n", array_map(
  fn($k, $v) => "$k: $v",
  array_keys($headers),
  $headers
)));

if ($ok) {
  echo '✅ Request sent! I’ll add you ASAP.';
} else {
  echo '❌ Oops, something went wrong sending the email.';
}
