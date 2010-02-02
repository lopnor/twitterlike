package TwitterLike::Schema::ResultSet::Application;
use strict;
use warnings;
use base 'TwitterLike::Schema::ResultSet';

sub create_from_form {
    my ($self, $user, $form) = @_;


    my $txn_guard = $self->result_source->schema->txn_scope_guard;

    my $key;
    while (1) {
        $key = $self->sha1_hex;
        $self->find({consumer_key => $key}) or last;
    };

    my $app = $self->create(
        {
            user_id => $user->id,
            %{$form->params},
            consumer_key => $key,
            consumer_secret => $self->sha1_hex,
        }
    );

    $txn_guard->commit;
    $app;
}

1;
