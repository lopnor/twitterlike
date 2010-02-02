package TwitterLike::Controller::OAuth;
use Ark 'Controller';
with 'Ark::ActionClass::Form',
    'TwitterLike::ActionClass::BasicAuth';

use TwitterLike::Models;

sub request_token :Local {
    my ($self, $c) = @_;
    my $token = models('Schema::Token')->create_request_token($c->req)
        or $c->detach('unauthorized');

    $c->res->body($token);
}

sub authorize :Local :BasicAuth :Form('TwitterLike::Form::Authorize') {
    my ($self, $c) = @_;
    my $token = models('Schema::Token')->token_to_authorize($c->req)
        or $c->detach('default');
    if ($c->req->method eq 'POST' && $self->form->submitted_and_valid) {
        $c->detach('authorized', $token);
    }
    $self->form->fill($c->req);
}

sub authorized :Private {
    my ($self, $c, $token) = @_;
    my $cb = models('Schema::Token')->authorize_token(
        {
            token => $token,
            user  => $c->stash->{user},
        }
    );
    if ($cb) {
        $c->redirect($cb);
    } else {
        $c->stash(
            {
                verifier => $token->verifier,
                __view_mt_template => 'oauth/authorized',
            }
        );
    }
}

sub authenticate :Local {
    my ($self, $c) = @_;

}

sub access_token :Local {
    my ($self, $c) = @_;

    my $token = models('Schema::Token')->create_access_token( $c->req )
        or $c->detach('unauthorized');

    $c->res->body($token);
}

sub unauthorized :Local {
    my ($self, $c) = @_;
    $c->res->status(401);
    $c->res->body('Unauthorized');
}

1;

