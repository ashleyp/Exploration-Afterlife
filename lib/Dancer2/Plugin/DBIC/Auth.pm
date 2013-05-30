package Dancer2::Plugin::DBIC::Auth;
use base 'Dancer2::Plugin::DBIC';

use Dancer2::Plugin;

register authed => sub {
  my $dsl     = shift;
  my $app     = $dsl->app;
  my $conf    = plugin_setting();
  my $user    = $app->session( $conf->{session_var} );
  if ( $user ) {
      return $user;
  } else {
      return $app->context->redirect( $conf->{login_route} );
  }
};

register auth => sub {
  my $dsl  = shift;
  my $conf = plugin_setting();
  my ( $username, $password ) = @_;

  my $user = $dsl->resultset( $conf->{user_table} )->find({
    username => $username,
    password => $password,
  });

  if ( $user ) {
      my $session = $dsl->app->session;
      my $user_data = {
          username   => $user->username,
          id         => $user->user_id,
      };
      $session->write($conf->{session_var} => $user_data);
      return $user_data;
  } else {
      return undef;
  }
};

register_plugin for_versions => [ 2 ] ;

1;

