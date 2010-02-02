? extends 'base';
? block header => 'setting up account...';
? block content => sub {
<?= include('form', $s->{form}, 'setup account') ?>
? };
