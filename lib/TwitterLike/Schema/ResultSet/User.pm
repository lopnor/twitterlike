package TwitterLike::Schema::ResultSet::User;
use strict;
use warnings;
use base 'TwitterLike::Schema::ResultSet';
use MIME::Base64 ();
use TwitterLike::Models;

sub create_from_form {
    my ($self, $args) = @_;
    my $form = $args->{form};
    my $info = $args->{openid};

    my $txn_guard = $self->result_source->schema->txn_scope_guard;

    my $openid = models('Schema::OpenID')->find(
        { id => $info->{hash}->{openid_id} }
    ) or return;
    
    my $user = $self->create( $form->params );
    
    $openid->update({user_id => $user->id});

    $txn_guard->commit;

    $user;
}

sub basic_auth {
    my ($self, $auth) = @_;

    if ($auth =~ /^Basic (.*)$/) {
        my($user, $pass) = split /:/, (MIME::Base64::decode($1) || ":");
        my $u = $self->find({username => $user}) or return;
        $u->check_password($pass) or return;
        return $u;
    }
}

1;
