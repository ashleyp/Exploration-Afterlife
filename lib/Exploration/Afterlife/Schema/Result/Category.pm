package Exploration::Afterlife::Schema::Result::Category;

use 5.12.0;
use base 'DBIx::Class::Core';

__PACKAGE__->table('category');
__PACKAGE__->add_columns(
    category_id => {
        data_type => 'integer',
        auto_increment => 1,
    },
    category_name => {
        data_type => 'text',
    }
);

__PACKAGE__->set_primary_key('category_id');
__PACKAGE__->has_many(
    articles => 'Exploration::Afterlife::Schema::Result::Article',
   'category_id'
);

1;
