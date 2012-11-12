#!/usr/bin/env perl

use 5.12.0;

use DBIx::Class::Migration::RunScript;

migrate {
    my $user_level_rs = shift->schema->resultset('UserLevel');

    $user_level_rs->populate([
        { user_level_name => "User" },
        { user_level_name => "Moderator" },
        { user_level_name => "Admin" },
    ]);
};
