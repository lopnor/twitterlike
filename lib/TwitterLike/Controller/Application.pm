package TwitterLike::Controller::Application;
use Ark 'Controller';
with 'Ark::ActionClass::Form',
    'TwitterLike::ActionClass::LoginUser';

sub auto :Private :LoginUser { 1 }

sub index :Path :Args(0) {
    my ($self, $c) = @_;
    $c->stash->{apps} = [ 
        models('Schema::Application')->search(
            {
                user_id => $c->user->obj->id,
            }
        )
    ];
}

sub item :Chained :PathPart('application') :CaptureArgs(1) {
    my ($self, $c, $id) = @_;
    $c->stash->{app} = models('Schema::Application')->search(
        {
            user_id => $c->user->obj->id,
            id => $id,
        }
    )->single;
}

sub show :Chained('item') :PathPart('') :Args(0) {

}

sub edit :Chained('item') :PathPart('edit') :Args(0) {

}

sub create :Local :Form('TwitterLike::Form::Newapp') {
    my ($self, $c) = @_;

    if ($c->req->method eq 'POST' and $self->form->submitted_and_valid) {
        my $app = models('Schema::Application')->create_from_form(
            $c->user->obj,
            $self->form
        );
        $c->redirect( $c->uri_for('application', $app->id) );
    }
}

1;
