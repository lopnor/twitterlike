package TwitterLike::Schema::ResultSet::OpenID;
use strict;
use warnings;
use base 'TwitterLike::Schema::ResultSet';

sub find_user {
    my ($self, $id, $info) = @_;

    my $openid = $self->find_or_create({url => $id});
    return {
        hash => {
            %$info,
            openid_id => $openid->id,
        },
        obj_builder => sub { $openid->user if $openid->user_id },
    };
}

sub from_session {
    my ($self, $info) = @_;
    my $openid = $self->find($info->{hash}->{openid_id}) or return;
    return {
        hash => $info->{hash},
        obj_builder => sub { $openid->user if $openid->user_id },
    };
}

1;
