package TwitterLike::ActionClass::BasicAuth;
use Any::Moose '::Role';
use TwitterLike::Models;

around ACTION => sub {
    my ($next, $self, $action, @args) = @_;

    if (my $realm = $action->attributes->{BasicAuth}->[0]) {
        my $c = $self->context;

        {
            $c->req->user and last;
            my $auth = $c->req->env->{HTTP_AUTHORIZATION} or last;
            my $u = models('Schema::User')->basic_auth($auth) or last;
            $c->req->env->{REMOTE_USER} = $u->username;
            $c->stash->{user} = $u;
        }
        unless ($c->req->user) {
            $c->res->status(401);
            $c->res->header('WWW-Authenticate' => "Basic realm=\"$realm\"");
            $c->res->body('Authorization required');
            return;
        }
    }

    $next->($self, $action, @args);
};

no Any::Moose '::Role';

sub _parse_BasicAuth_attr {
    my ($self, $name, $value) = @_;
    return BasicAuth => $value || 'BasicAuth';
}

1;
