package TwitterLike::Controller::Statuses;
use Ark 'Controller';
with 'TwitterLike::ActionClass::API',
    'TwitterLike::ActionClass::Protected';

use TwitterLike::Models;

sub auto :Private :Protected {
    1;
}

sub update :API {
    my ($self, $c) = @_;
    {
        $c->req->method eq 'POST' or last;
        my $status = models('Schema::Status')->create_from_req($c->req) or die;
        $c->stash->{json} = $status->format;
        return;
    }
    $c->res->status(403);
    $c->res->body('forbidden');
}

sub replies :API {
    my ($self, $c) = @_;
    $c->stash->{json} = [];
}

sub home_timeline :API {
    my ($self, $c) = @_;

    my $since = $c->req->param('since_id');

    my @statuses = map {
        $_->format
    } models('Schema::Status')->search(
        {
            user_id => $c->stash->{user}->id,
            $since ? (id => {'>' => $since}) : (),
        },
        {
            order_by => { -desc => 'id' },
            rows => $c->req->param('count') || 20,
        }
    );

    $c->stash->{json} = \@statuses;
}

1;
