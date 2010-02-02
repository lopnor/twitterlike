package TwitterLike::Controller::DirectMessages;
use Ark 'Controller';
with 'TwitterLike::ActionClass::BasicAuth',
    'TwitterLike::ActionClass::API';

use TwitterLike::Models;

has '+namespace' => default => 'direct_messages';

sub auto :Private :BasicAuth {1}

sub index :API {
    my ($self, $c) = @_;
    $c->stash->{json} = [];
}

1;
