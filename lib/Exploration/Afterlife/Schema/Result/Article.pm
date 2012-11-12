package Exploration::Afterlife::Schema::Result::Article;
use base 'DBIx::Class::Core';

__PACKAGE__->table('article');
__PACKAGE__->add_columns(
    article_id => {
        data_type => 'integer',
        auto_increment => 1,
    },
    content => {
        data_type => 'text',
    },
    title => {
        data_type => 'text',
    },
    date_posted => {
        data_type => 'integer',
    },
    category_id => {
        data_type => 'integer',
        is_foreign_key => 1,
    },
    posted_by_user_id => {
        data_type => 'integer',
        is_foreign_key => 1,
    }
);

__PACKAGE__->set_primary_key('article_id');

__PACKAGE__->belongs_to(
   posted_by  => 'Exploration::Afterlife::Schema::Result::Users',
   { 'foreign.user_id' => 'self.posted_by_user_id' }
);

__PACKAGE__->belongs_to(
   category => 'Exploration::Afterlife::Schema::Result::Category',
   { 'foreign.category_id' => 'self.category_id' }
);


1;
