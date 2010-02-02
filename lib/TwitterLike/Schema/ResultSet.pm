package TwitterLike::Schema::ResultSet;
use strict;
use warnings;
use base 'DBIx::Class::ResultSet';
use Digest::SHA1;

sub sha1_hex {
    my ($self, $args) = @_;
    return Digest::SHA1::sha1_hex($args || ( time, rand, $$ ));
}

1;
