package TwitterLike::View::XML;
use Ark 'View';
use XML::Simple;

has expose_stash => (
    is => 'rw',
    default => 'json',
);

has xml_driver => (
    is => 'rw',
    isa => 'Object',
    lazy => 1,
    default => sub {
        XML::Simple->new(
            XMLDecl => "<?xml version='1.0' encoding='UTF-8'?>",
            KeepRoot => 1, 
            NoAttr => 1
        );
    }
);

has xml_dumper => (
    is => 'rw',
    isa => 'CodeRef',
    lazy => 1,
    default => sub {
        my $self = shift;
        sub { $self->xml_driver->XMLout(@_) };
    }
);


sub process {
    my ($self, $c) = @_;

    my $data = $c->stash->{$self->expose_stash};

    my $output = $self->xml_dumper->($data);

    $c->res->content_type('application/xml; charset=utf-8');
    $c->res->body($output);
}

1;
