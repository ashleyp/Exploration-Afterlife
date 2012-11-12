#!/usr/bin/env perl

use 5.12.0;

use DBIx::Class::Migration::RunScript;

migrate {
    my $category_rs = shift->schema->resultset('Category');

    $category_rs->populate([
        { category_name => "Video Evidence" },
        { category_name => "News" },
    ]);
};
