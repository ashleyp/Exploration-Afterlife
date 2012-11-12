package Exploration::Afterlife;
use Dancer ':syntax';
use Dancer::Plugin::DBIC 'schema';

our $VERSION = '0.1';

get '/' => sub {
    my @articles = schema->resultset('Article')->all;
    template 'index', { route => '/', articles => \@articles };
};

get '/evidence' => sub {
    my @categories            = schema->resultset('Category')->all;
    my @articles              = schema->resultset('Article')->all;
    template 'evidence', {
        route => '/evidence',
        articles => \@articles,
        categories => \@categories,
    };
};

get '/evidence/category/:category' => sub {
    my $category_name         = params->{category};
    my @categories            = schema->resultset('Category')->all;
    my $find_category         = schema->resultset('Category')->find( { category_name => $category_name } );
    my @articles_for_category = $find_category->articles;
    template 'evidence', {
        route => "/evidence/category/$category_name",
        articles => \@articles_for_category,
        categories => \@categories,
    };
};

post '/login' => sub {
    my $username = param('username');
    my $password = param('password');
    my $user_ok  = auth_user( $username, $password );
    if ( $user_ok ) {
        session username => $username;
        session user_level => $user_ok->{level_id};
    }
    redirect param('route');
};

true;
