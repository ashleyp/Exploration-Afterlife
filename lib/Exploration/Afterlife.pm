package Exploration::Afterlife;
use Dancer ':syntax';
use Dancer::Plugin::DBIC 'schema';
use Dancer::Plugin::Auth::RBAC;

our $VERSION = '0.1';

get '/' => sub {
    my @articles = schema->resultset('Article')->all;
    template 'index', { articles => \@articles };
};

get '/login' => sub {
    template 'login';
};

get '/evidence' => sub {
    my @categories            = schema->resultset('Category')->all;
    my @articles              = schema->resultset('Article')->all;
    template 'evidence', {
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
        articles => \@articles_for_category,
        categories => \@categories,
    };
};

post '/login' => sub {
    my $username = param('username');
    my $password = param('password');
    my $user_ok  = auth( $username, $password );
    if ( !$user_ok->errors ) {
        session username => $user_ok->{username};
        session user_level => $user_ok->{user_level};
    } else {
        print "FAILLLURE\n\n\n";
    }
    redirect '/';
};

true;
