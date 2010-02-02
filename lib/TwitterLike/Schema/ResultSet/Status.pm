package TwitterLike::Schema::ResultSet::Status;
use strict;
use warnings;
use base 'TwitterLike::Schema::ResultSet';
use TwitterLike::Models;

sub create_from_req {
    my ($self, $req) = @_;

    my $users = models('Schema::User');
    my $text = $req->param('status') or return;
    my ($reply_to_username) = $text =~ m/\@(\w+)/;

    my $txn_guard = $self->result_source->schema->txn_scope_guard;

    my $user = $users->find({username => $req->user}) or return;

    my $reply_user = $users->find({username => $reply_to_username}) 
        if $reply_to_username;

    my $reply_id = $req->param('in_reply_to_status_id');
    my $in_reply_to = $self->search(
        {
            id => $reply_id,
            user_id => $reply_user->id || 0,
        }
    )
        if $reply_id;

    my $status = $self->create(
        {
            user_id => $user->id,
            text => $text,
            $in_reply_to ? (in_reply_to_status_id => $reply_id) : (),
            $reply_user ? (in_reply_to_user_id => $reply_user->id) : (),
        }
    );

    $txn_guard->commit;

    $status;

}

1;
