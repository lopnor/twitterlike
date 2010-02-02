package TwitterLike::Schema::Result::Token;
use strict;
use warnings;
use base 'DBIx::Class';
use TwitterLike::Models;

__PACKAGE__->load_components(qw(TimeStamp Core));
__PACKAGE__->table('token');
__PACKAGE__->add_columns(
    id => {
        data_type => 'INT',
        is_nullable => 0,
        is_auto_increment => 1,
        extra => {
            unsined => 1,
        },
    },
    application_id => {
        data_type => 'INT',
        is_nullable => 0,
        extra => {
            unsigned => 1,
        },
    },
    user_id => {
        data_type => 'INT',
        is_nullable => 1,
        extra => {
            unsigned => 1,
        },
    },
    token => {
        data_type => 'CHAR',
        size => 40,
        is_nullable => 0,
    },
    secret => {
        data_type => 'CHAR',
        size => 40,
        is_nullable => 0,
    },
    verifier => {
        data_type => 'CHAR',
        size => 16,
        is_nullable => 1,
    },
    type => {
        data_type => 'CHAR',
        size => 16,
        is_nullable => 0,
    },
    created_at => {
        data_type => 'DATETIME',
        set_on_create => 1,
    },
);

__PACKAGE__->set_primary_key('id');
__PACKAGE__->belongs_to(application => 'TwitterLike::Schema::Result::Application' => 'application_id');
__PACKAGE__->belongs_to(user => 'TwitterLike::Schema::Result::User' => 'user_id');

1;
