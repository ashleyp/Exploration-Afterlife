# ABSTRACT: Dancer::Plugin::Auth::RBAC authentication via SQLite!

package Dancer::Plugin::Auth::Simple::DBIC;

BEGIN {
    $Dancer::Plugin::Auth::Simple::DBIC::VERSION = '1.0';
}

use strict;
use warnings;

use Dancer::Plugin::DBIC 'schema';
use Dancer qw/:syntax/;

sub new {
    my $class = shift;
    my $self  = {};
    bless $self, $class;
    return $self;
}

sub credentials {
    my $self = shift;
    if (@_) {
        return session 'user' => @_;
    }
    else {
        return session('user');
    }
}

sub errors {
    my ($self, @errors) = @_;
    my $user = session('user');
    push @{$user->{error}}, @errors; 
    #return session 'user' => $user;
    session 'user' => $user;
    return @errors;
}

sub authorize {

    my ( $self, $options, @arguments ) = @_;
    my ( $username, $password ) = @arguments;
    if ( $username ) {
        # authorize a new account using supplied credentials

        unless ( $password ) {
            $self->errors('login and password are required');
            return 0;
        }

        my $user_data = schema->resultset('Users')->find(
            {
                username => $username,
                password => $password,
            }
        );

        if ( $user_data ) {
            my $session_data = {
                username   => $user_data->username,
                id         => $user_data->user_id,
                user_level => $user_data->user_level->user_level_id,
                error      => [],
            };
            return $self->credentials($session_data);
        }
        else {
            $self->errors('login and/or password is invalid');
            return 0;
        }
    }
    else {

        # check if current user session is authorized
        my $user = $self->credentials;
        if ( $user->{username} && !@{ $user->{error} } ) {
            return $user;
        }
        else {
            $self->errors( 'you are not authorized', 'your session may have ended' );
            return 0;
        }

    }
    return 0;
}

1;

__END__
=pod

=head1 NAME

Dancer::Plugin::Auth::RBAC::Credentials::DBIC - Dancer::Plugin::Auth::RBAC authentication via DBIx::Class

=head1 VERSION

version 1.103430

=head1 SYNOPSIS

    # in your app code
    my $auth = auth($login, $password);
    if (!$auth->errors()) {
        # login successful
    }
    
    # use your own encryption (if the user account password is encrypted)
    my $auth = auth($login, encrypt($password));
    if (!$auth->errors()) {
        # login successful
    }

=head1 DESCRIPTION

Dancer::Plugin::Auth::RBAC::Credentials::DBIC uses a DBIx::Class schema class
as the application's user management system.

=head1 METHODS

=head2 authorize

The authorize method (found in every authentication class) validates a user against
the defined datastore using the supplied arguments and configuration file options.

=head1 CONFIGURATION

    plugins:
      Auth::RBAC:
        credentials:
          class: SQLite

=head1 DATABASE SETUP

    # users table (feel free to add more columns as you see fit)
    
    CREATE TABLE users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name VARCHAR(255) DEFAULT NULL,
    username VARCHAR(255) NOT NULL,
    password TEXT NOT NULL,
    roles TEXT
    );
    
    # create an initial adminstrative user (should probably encrypt the password)
    # Note! this module is not responsible for creating user accounts, it simply
    # provides a consistant authentication framework
    
    INSERT INTO users (name, username, password, roles)
    VALUES ('Administrator', 'admin', '*****', 'guest, user, admin');

=head1 AUTHOR

  Ashley Pope <ashleyp@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by awncorp.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

