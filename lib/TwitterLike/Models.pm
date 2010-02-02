package TwitterLike::Models;
use strict;
use warnings;
use Ark::Models '-base';

register Schema => sub {
    my $self = shift;
    my $conf = $self->get('conf')->{database}
        or die 'requires database config';
    $self->ensure_class_loaded('TwitterLike::Schema');
    TwitterLike::Schema->connect(@$conf);
};

for my $table (qw(User Status Application Token OpenID)) {
    register "Schema::$table" => sub {
        my $self = shift;
        $self->get('Schema')->resultset($table);
    };
}

register cache => sub {
    my $self = shift;
    my $conf = $self->get('conf')->{cache}
        or die 'requires cache config';

    $self->ensure_class_loaded('Cache::FastMmap');
    Cache::FastMmap->new(%$conf);
};

1;
