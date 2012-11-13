package Exploration::Afterlife::Schema::Result::UserLevel;

use base 'DBIx::Class::Core';

__PACKAGE__->table('user_level');
__PACKAGE__->add_columns(
    user_level_id => {
        data_type => 'integer',
        auto_increment => 1,
    },
    user_level_name => {
        data_type => 'text',
    }
);

__PACKAGE__->set_primary_key('user_level_id');

__PACKAGE__->has_many(
    user_level => 'Exploration::Afterlife::Schema::Result::Users',
    {
        'foreign.user_level_id' => 'self.user_level_id',
    }
);

1;
