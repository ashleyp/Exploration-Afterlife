package Exploration::Afterlife;
use Dancer2;
use Dancer2::Plugin::DBIC qw/rset/;
use Dancer2::Plugin::DBIC::Auth;

our $VERSION = '0.1';

get '/' => sub {
    my @articles = rset('Article')->all;
    template index => { articles => \@articles };
};

get '/login' => sub {
    template 'login';
};

post '/login' => sub {
    my $user_ok = auth( param('username'), param('password') );
    if( $user_ok ) {
        redirect param('path') || '/';
    } else {
        var requested_path => param('path');
        redirect '/login?error=true';
    }
};

get '/logout' => sub {
    context->destroy_session;
    template 'logout';
};

get '/add_user' => sub {
    my $user_data = authed;
    template 'add_user';
};

post '/add_user' => sub {
    my $user_data = authed;
    my $add_article = rset('Users')->create(
        {
            user_level_id => 1,
            username      => param('username'),
            password      => param('password'),
            firstname     => param('firstname'),
            lastname      => param('lastname'),
            email         => param('email'),
        }
    );
};

get '/evidence' => sub {
    my @categories = rset('Category')->all;
    my @articles   = rset('Article')->all;
    template 'evidence',
      {
        articles   => \@articles,
        categories => \@categories,
      };
};

get '/evidence/category/:category' => sub {
    my @categories    = rset('Category')->all;
    my $find_category = rset('Category')->find({ category_name => param('category') });
    my @articles_for_category = $find_category->articles;
    template 'evidence',
      {
        articles   => \@articles_for_category,
        categories => \@categories,
      };
};

get '/add_article' => sub {
    my $user_data = authed;
    my @categories = rset('Category')->all;
    template add_article => { categories => \@categories };
};

post '/add_article' => sub {
    my $user_data = authed;
    my $add_article = rset('Article')->create(
        {
            content           => param('content'),
            title             => param('title'),
            category_id       => param('category'),
            date_posted       => time(),
            posted_by_user_id => $user_data->{id},
        }
    );
    redirect '/';
};

get '/edit_article/:article_id' => sub {
    my $user_data = authed;
    my @categories = rset('Category')->all;
    my $article    = rset('Article')->find({ article_id => param('article_id') });
    template edit_article => { article => $article, categories => \@categories };
};

post '/edit_article/:article_id' => sub {
    my $user_data = authed;
    my $article    = rset('Article')->find({ article_id => param('article_id') });
    $article->update(
        {
            content     => param('content'),
            title       => param('title'),
            category_id => param('category'),
        }
    );
    redirect '/evidence';
};

true;
