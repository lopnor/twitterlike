package TwitterLike::Schema::Result::OpenID;
use strict;
use warnings;
use base 'DBIx::Class';

__PACKAGE__->load_components(qw(TimeStamp Core));
__PACKAGE__->table('openid');
__PACKAGE__->add_columns(
    id => {
        data_type => 'INT',
        is_nullable => 0,
        is_auto_increment => 1,
        extra => {
            unsigned => 1,
        }
    },
    user_id => {
        data_type => 'INT',
        is_nullable => 1,
        default => 0,
        extra => {
            unsigned => 1,
        }
    },
    url => {
        data_type => 'VARCHAR',
        size => 255,
        is_nullable => 0,
    },
    created_at => {
        data_type => 'DATETIME',
        set_on_create => 1,
        timezone => TwitterLike::Models->get('conf')->{time_zone},
    },
    updated_at => {
        data_type => 'DATETIME',
        set_on_create => 1,
        set_on_update => 1,
        timezone => TwitterLike::Models->get('conf')->{time_zone},
    },
);
__PACKAGE__->set_primary_key('id');
__PACKAGE__->add_unique_constraint(['url']);
__PACKAGE__->belongs_to('user', 'TwitterLike::Schema::Result::User', 'user_id');

1;
