? extends 'base';

? block content => sub {
    <a href="<?= $c->uri_for('/application') ?>">setup applications</a>
<?= include('form', $s->{form}, 'save settings') ?>
? }
