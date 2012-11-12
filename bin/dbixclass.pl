#!/usr/bin/env perl
use Exploration::Afterlife::Schema;
use Data::Dumper;

my $schema = Exploration::Afterlife::Schema->connect( 'dbi:SQLite:dbname=share/exploration-afterlife-schema.db' );

my $category = $schema->resultset('Category')->find( { category_name => $ARGV[0] } );

print "Finding articles for " . $ARGV[0] . " .. \n";
for my $article ( $category->articles ) {
    print "Article: " . $article->title, "\n";
}

__END__
my $user = $schema->resultset('Users')->find( { username => $ARGV[0] });

print "Finding articles by user: " . $ARGV[0], "\n";

for my $article ( $user->articles ) {
    print "Article: " . $article->title, "\n";
}
    
__END__

my @articles = $schema->resultset('Article')->all;

for my $article ( @articles ) {
    print "Testing: " . $article->category->category_name, "\n";
}
