package TwitterLike::Controller::Favorites;
use Ark 'Controller';
with 'TwitterLike::ActionClass::BasicAuth',
    'TwitterLike::ActionClass::API';

use TwitterLike::Models;

sub auto :Private :BasicAuth {1}

sub index :API {
    my ($self, $c) = @_;
    $c->stash->{json} = [];
}

1;

