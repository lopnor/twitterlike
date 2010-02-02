package TwitterLike::Schema::Result::Status;
use strict;
use warnings;
use base 'DBIx::Class';
use TwitterLike::Models;

__PACKAGE__->load_components(qw(TimeStamp Core));
__PACKAGE__->table('status');
__PACKAGE__->add_columns(
    id => {
        data_type => 'INT',
        is_nullable => 0,
        is_auto_increment => 1,
        extra => {
            unsigned => 1,
        },
    },
    text => {
        data_type => 'VARCHAR',
        size => 255,
    },
    in_reply_to_status_id => {
        data_type => 'INT',
        is_nullable => 1,
        extra => {
            unsigned => 1,
        },
    },
    in_reply_to_user_id => {
        data_type => 'INT',
        is_nullable => 1,
        extra => {
            unsigned => 1,
        },
    },
    user_id => {
        data_type => 'INT',
        is_nullable => 0,
        extra => {
            unsigned => 1,
        },
    },
    created_at => {
        data_type => 'DATETIME',
        set_on_create => 1,
        timezone => TwitterLike::Models->get('conf')->{time_zone},
    },
);
__PACKAGE__->set_primary_key('id');
__PACKAGE__->belongs_to(user => 'TwitterLike::Schema::Result::User' => 'user_id');

sub format {
    my ($self) = @_;
    return {
        created_at => $self->created_at->set_time_zone('UTC')->strftime("%a %b %d %T %z %Y"),
        id => $self->id,
        text => $self->text,
        $self->in_reply_to_status_id ? 
            (in_reply_to_status_id => $self->in_reply_to_status_id) : (),
        $self->in_reply_to_user_id ?
            (in_reply_to_user_id => $self->in_reply_to_user_id) : (),
        user => { 
            id => $self->user->id,
            name => $self->user->fullname,
            screen_name => $self->user->username,
        }
    };
}

1;
