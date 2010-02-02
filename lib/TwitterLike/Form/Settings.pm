package TwitterLike::Form::Settings;
use Ark 'Form';

param 'fullname' => (
    label => 'Full Name',
    type  => 'text',
    constraints => [
        'NOT_NULL',
    ],
);

param 'password' => (
    label => 'Password (for BasicAuth APIs)',
    type => 'password',
);

1;
