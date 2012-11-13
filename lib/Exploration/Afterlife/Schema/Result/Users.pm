package Exploration::Afterlife::Schema::Result::Users;

use base qw/DBIx::Class::Core/;

__PACKAGE__->table('users');
__PACKAGE__->add_columns(
    user_id => {
        data_type => 'integer',
        auto_increment => 1,
    },
    user_level_id => {
        data_type => 'integer',
        is_foreign_key => 1,
    },
    username => {
        data_type => 'text',
    },
    password => {
        data_type => 'text',
    },
    lastname => {
        data_type => 'text',
    },
    firstname => {
        data_type => 'text',
    },
    email => {
        data_type => 'text',
    },
);

__PACKAGE__->set_primary_key('user_id');
__PACKAGE__->add_unique_constraint("username", ["username"]);

__PACKAGE__->belongs_to(
    user_level => 'Exploration::Afterlife::Schema::Result::UserLevel',
    { 'foreign.user_level_id' => 'self.user_level_id' }
);

__PACKAGE__->has_many(
    articles => 'Exploration::Afterlife::Schema::Result::Article',
    { 'foreign.posted_by_user_id' => 'self.user_id' }
);

1;
