#!/usr/bin/env perl

use 5.12.0;

use DBIx::Class::Migration::RunScript;

migrate {
    my $article_rs = shift->schema->resultset('Article');

    $article_rs->populate([
        {
            content           => "This is the content of an article",
            title             => "Test article",
            date_posted       => 12345,
            category_id       => 2,
            posted_by_user_id => 1,
        },
        {
            content           => "Video Evidence @ Japan <insert video here>",
            title             => "Japan video evidence",
            date_posted       => 54321,
            category_id       => 1,
            posted_by_user_id => 2,
        },
    ]);
};

