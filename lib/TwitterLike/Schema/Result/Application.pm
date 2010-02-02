package TwitterLike::Schema::Result::Application;
use strict;
use warnings;
use base 'DBIx::Class';

__PACKAGE__->load_components(qw(TimeStamp Core));
__PACKAGE__->table('application');
__PACKAGE__->add_columns(
    id => {
        data_type => 'INT',
        is_nullable => 0,
        is_auto_increment => 1,
        extra => {
            unsigned => 1,
        }
    },
    name => {
        data_type => 'VARCHAR',
        size => 255,
        is_nullable => 0,
    },
    user_id => {
        data_type => 'INT',
        is_nullable => 0,
        extra => {
            unsigned => 1,
        }
    },
    callback_url => {
        data_type => 'VARCHAR',
        size => 255,
    },
    consumer_key => {
        data_type => 'CHAR',
        size => 40,
        is_nullable => 0,
    },
    consumer_secret => {
        data_type => 'CHAR',
        size => 40,
        is_nullable => 0,
    },
    created_at => {
        data_type => 'DATETIME',
        set_on_create => 1,
    },
    updated_at => {
        data_type => 'DATETIME',
        set_on_create => 1,
        set_on_update => 1,
    },
);

__PACKAGE__->set_primary_key('id');
__PACKAGE__->add_unique_constraint(['consumer_key']);
__PACKAGE__->belongs_to('user', 'TwitterLike::Schema::Result::User', 'user_id');
