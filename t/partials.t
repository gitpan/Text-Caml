use strict;
use warnings;

use Test::More tests => 3;

use Text::Caml;

my $renderer = Text::Caml->new(templates_path => 't/templates');

my $output = $renderer->render('{{>partial}}');
is $output => 'Hello from partial!';

$output =
  $renderer->render('{{>partial-with-directives}}', {name => 'foo'});
is $output => 'Hello foo!';

$output =
  $renderer->render('{{>partial-with-recursion}}', {name => 'foo'});
is $output => '*Hello foo!*';
