package TwitterLike::ActionClass::LoginUser;
use Any::Moose '::Role';
use TwitterLike::Models;

around ACTION => sub {
    my ($next, $self, $action, @args) = @_;

    if ($action->attributes->{LoginUser}->[0]) {
        my $c = $self->context;
        
        my $user = $c->user;
        unless ($user) {
            $c->session->set(nexturl => $c->req->uri);
            $c->redirect($c->uri_for('/login'));
            return;
        }
        unless ($user->obj) {
            $c->session->set(nexturl => $c->req->uri);
            $c->redirect($c->uri_for('/setup'));
            return;
        }
    }

    $next->($self, $action, @args);
};

sub _parse_LoginUser_attr {
    my ($self, $name, $value) = @_;
    return LoginUser => 1;
}

1;
