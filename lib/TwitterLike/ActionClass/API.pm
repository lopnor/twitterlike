package TwitterLike::ActionClass::API;
use Any::Moose '::Role';

sub _parse_API_attr {
    my ($self, $name, $value) = @_;

    my $ext = "(?:\.json|\.xml|)\$(?#api)";

    if (! $value && $name eq 'index') {
        my $regex = '^' . $self->namespace . $ext;
        return $self->_parse_Regex_attr($name, $regex);
    }
    my $regex = '^' . ($value || $name) . $ext;
    return $self->_parse_LocalRegex_attr($name, $regex);
}

around ACTION => sub {
    my ($next, $self, $action, @args) = @_;
    $next->($self, $action, @args);
    if (($action->attributes->{Regex}->[0] || '') =~ m{\(\?\#api\)$}) {
        my $c = $self->context;
        unless ($c->res->body || $c->res->status =~ m{^3\d{2}$}) {
            my $type = [ split(/\./, $c->req->path) ]->[1] || 'XML';
            $c->forward($c->view(uc $type));
        }
    }
};

1;
