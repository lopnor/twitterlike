<html>
<head>
    <title><? block title => 'something like twitter' ?></title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.4.1/jquery.min.js"></script>
</head>
<body>
<div id="header">
? block header => sub {
<ul>
? if (my $user = $c->user) {
    <li>hello, <?= $user->obj ? $user->obj->username : 'new user' ?>!</li>
    <li><a href="<?= $c->uri_for('/settings') ?>">settings</a></li>
    <li><a href="<?= $c->uri_for('/logout') ?>">logout</a></li>
? } else {
    <li>hello, guiest!</li>
    <li><a href="<?= $c->uri_for('/login') ?>">login</a></li>
? }
</ul>
? };
</div>
<div id="content">
? block content => '';
</div>
</body>
</html>
