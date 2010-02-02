package TwitterLike::Form::Newapp;
use Ark 'Form';

param 'name' => (
    label => 'Application Name',
    type => 'text',
    constraints => [
        'NOT_NULL',
    ],
);

param 'callback_url' => (
    label => 'Callback URL (for web application)',
    type => 'url',
);

1;
