? extends 'base';

? block content => sub {
<dl>
? for my $attr (qw(name callback_url consumer_key consumer_secret)) {
<dt><?= $attr ?></dt>
<dd><?= $s->{app}->$attr ?></dd>
? }
</dl>
? };
