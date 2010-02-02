package TwitterLike::ActionClass::Protected;
use Any::Moose '::Role';
use MIME::Base64 ();
use TwitterLike::Models;

around ACTION => sub {
    my ($next, $self, $action, @args) = @_;

    if (my $realm = $action->attributes->{Protected}->[0]) {
        my $c = $self->context;
        my $user;
        {
            if ($c->user && $c->user->obj) {
                $user = $c->user->obj and last;
            }
            $user = $c->req->user and last;
            my $auth = $c->req->env->{HTTP_AUTHORIZATION};
            if (($auth || '') =~ /^Basic (.*)$/) {
                $user = models('Schema::User')->basic_auth($auth);
            } else {
                my $token = models('Schema::Token')->protected_resource_request($c->req);
                $user = $token->user;
                $c->stash->{application} = $token->application;
            }
        }
        if ($user) {
            $c->req->env->{REMOTE_USER} = $user->username;
            $c->stash->{user} = $user;
        } else {
            $c->res->status(401);
            $c->res->header('WWW-Authenticate' => "Basic realm=\"$realm\"");
            $c->res->body('Authorization required');
            return;
        }
    }

    $next->($self, $action, @args);
};

no Any::Moose '::Role';

sub _parse_Protected_attr {
    my ($self, $name, $value) = @_;
    return Protected => $value || 'Protected';
}

1;
