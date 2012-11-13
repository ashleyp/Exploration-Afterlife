package Exploration::Afterlife;
use Dancer ':syntax';
use Dancer::Plugin::DBIC 'schema';
use Dancer::Plugin::Auth::Simple;

our $VERSION = '0.1';

get '/' => sub {
    my @articles = schema->resultset('Article')->all;
    template 'index', { articles => \@articles };
};

get '/login' => sub {
    template 'login';
};

get '/logout' => sub {
    session->destroy;
    template 'logout';
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
    my @categories            = schema->resultset('Category')->all;
    my $find_category         = schema->resultset('Category')->find({ 
            category_name => param('category') 
    });
    my @articles_for_category = $find_category->articles;
    template 'evidence', {
        articles => \@articles_for_category,
        categories => \@categories,
    };
};

get '/add_article' => sub {
    my $user_data   = authd;
    my @categories = schema->resultset('Category')->all;
    template 'add_article', { categories => \@categories };
};

post '/add_article' => sub {
    my $user_data   = authd;
    my $add_article = schema->resultset('Article')->create({
            content           => param('content'),
            title             => param('title'),
            category_id       => param('category'),
            date_posted       => time(),
            posted_by_user_id => $user_data->{id},
    });
    redirect '/';
};


post '/login' => sub {
    my $user_ok  = auth( param('username'), param('password') );
    if ( !$user_ok->errors ) {
        redirect '/';
    } else {
        redirect '/login?error=true';
    }
};

true;
