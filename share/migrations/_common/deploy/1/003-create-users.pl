#!/usr/bin/env perl

use 5.12.0;

use DBIx::Class::Migration::RunScript;

migrate {
    my $users_rs = shift->schema->resultset('User');

    $users_rs->populate([
        {
            user_level_id => 1,
            username      => "ashleyp",
            password      => '{CRYPT}$2a$04$IwsMqJkcacvrj.P1ewBHC.g/mIJ7GP22sekOWIrOLCSJxYpYj.0yC',
            lastname      => "Pope",
            firstname     => "Ashley",
            email         => "irashp\@gmail.com",
        },
        {
            user_level_id => 3,
            username      => "suzannep",
            password      => '{CRYPT}$2a$04$2hBt1sHi0kkT3ALuC5MAUO3sQMz0JicqLEAD1ZmbMHmP2dpkDAcC.',
            lastname      => "Pope",
            firstname     => "Suzanne",
            email         => "popesltp\@gmail.com",
        },

    ]);
};
