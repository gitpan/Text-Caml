use strict;
use warnings;

use Test::More tests => 7;

use Text::Caml;

my $renderer = Text::Caml->new;
my $output;

$output = $renderer->render(
    '{{lamda}}',
    {   lamda => sub { }
    }
);
is $output => '';

$output = $renderer->render(
    '{{lamda}}',
    {   lamda => sub {0}
    }
);
is $output => '0';

$output = $renderer->render(
    '{{lamda}}',
    {   lamda => sub {'text'}
    }
);
is $output => 'text';

$output = $renderer->render(
    '{{lamda}}',
    {   lamda => sub {'{{var}}'},
        var   => 'text'
    }
);
is $output => 'text';

$output = $renderer->render(
    '{{#lamda}}Hello{{/lamda}}',
    {   lamda => sub {'{{var}}'},
        var   => 'text'
    }
);
is $output => 'text';

my $wrapped = sub {
    my $self = shift;
    my $text = shift;

    return '<b>' . $self->render($text, @_) . '</b>';
};

$output = $renderer->render(<<'EOF', {name => 'Willy', wrapped => $wrapped});
{{#wrapped}}
{{name}} is awesome.
{{/wrapped}}
EOF
is $output => "<b>Willy is awesome.</b>";

$output = $renderer->render(<<'EOF', {wrapper => sub {$_[1] =~ s/r/z/; $_[1]}, list => [qw/foo bar/]});
{{#list}}
  {{#wrapper}}
    {{.}}
  {{/wrapper}}
{{/list}}
EOF
like $output => qr/foo\s+baz/;
