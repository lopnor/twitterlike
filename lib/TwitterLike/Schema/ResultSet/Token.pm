package TwitterLike::Schema::ResultSet::Token;
use strict;
use warnings;
use base 'TwitterLike::Schema::ResultSet';
use Net::OAuth;
$Net::OAuth::PROTOCOL_VERSION = Net::OAuth::PROTOCOL_VERSION_1_0A;
use TwitterLike::Models;

sub create_request_token {
    my ($self, $req) = @_;

    my $type = "request token";

    my $txn_guard = $self->result_source->schema->txn_scope_guard;

    my $app = models('Schema::Application')->search(
        {
            consumer_key => $req->param('oauth_consumer_key')
        }
    )->single or return;

    my $uri = $req->uri->clone;
    $uri->query_form([]);

    my $oauth = Net::OAuth->request($type)->from_hash(
        $req->params,
        request_method => $req->method,
        request_url => $uri,
        consumer_secret => $app->consumer_secret,
    );
    $oauth->verify or return;

    my $token = $self->create(
        {
            application_id => $app->id,
            token => $self->sha1_hex,
            secret => $self->sha1_hex,
            type => $type,
        }
    );

    my $res = Net::OAuth->response($type)->new(
        token => $token->token,
        token_secret => $token->secret,
        callback_confirmed => 'false',
    );
    $txn_guard->commit;

    return $res->to_post_body;
}

sub token_to_authorize {
    my ($self, $req) = @_;
    return $self->search(
        {
            token => $req->param('oauth_token'),
            type => 'request token',
            verifier => undef,
        }
    )->single;
}

sub authorize_token {
    my ($self, $args) = @_;
    my $token = $args->{token};
    my $user = $args->{user};

    my $rand;
    $rand .= int(rand(10)) for (1 .. 16);

    $token->update( 
        { 
            verifier => $rand, 
            user_id  => $user->id,
        } 
    );
    if ( my $cb = $token->application->callback_url ) {
        return Net::OAuth->response('user auth')->new(
            token => $token->token,
            verifier => $token->verifier,
        )->to_url($cb);
    }
}

sub create_access_token {
    my ($self, $req) = @_;

    my $type = 'access token';
    my $uri = $req->uri->clone;
    $uri->query_form([]);

    my $txn_guard = $self->result_source->schema->txn_scope_guard;

    my $req_token = $self->search(
        {
            token => $req->param('oauth_token'),
            verifier => $req->param('oauth_verifier'),
            type => 'request token',
        }
    )->single or return;
    
    my $app = $req_token->application or return;
    $app->consumer_key eq $req->param('oauth_consumer_key') or return;

    my $oauth = Net::OAuth->request($type)->from_hash(
        $req->params,
        request_method => $req->method,
        request_url => $uri,
        token_secret => $req_token->secret,
        consumer_secret => $app->consumer_secret,
    );
    $oauth->verify or return;

    my $token = $self->create(
        {
            application_id => $app->id,
            user_id => $req_token->user_id,
            token => $self->sha1_hex,
            secret => $self->sha1_hex,
            type => $type,
        }
    );

    $req_token->delete;

    my $res = Net::OAuth->response($type)->new(
        token => $token->token,
        token_secret => $token->secret,
        extra_params => {
            user_id => $token->user_id,
            screen_name => $token->user->username,
        },
    );
    $txn_guard->commit;

    return $res->to_post_body;
}

sub protected_resource_request {
    my ($self, $req) = @_;

    my $uri = $req->uri->clone;
    $uri->query_form([]);

    my $token = $self->search( 
        { 
            token => $req->param('oauth_token'),
            type => 'access token',
        }
    )->single or return;
    my $app = $token->application;
    $app->consumer_key eq $req->param('oauth_consumer_key') or return;
    my $oauth = Net::OAuth->request('protected resource')->from_post_body(
        $req->raw_body,
        request_method => $req->method,
        request_url => $uri,
        token_secret => $token->secret,
        consumer_secret => $app->consumer_secret,
    );
    $oauth->verify or return;
    return $token;
}

1;
