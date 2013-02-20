use strict;
use warnings;

use Test::More;
use Plack::Test;

use HTTP::Request::Common;
use Data::Dumper;
local $Data::Dumper::Terse  = 1;
local $Data::Dumper::Purity = 1;

use Plack::Middleware::Woothee;

my $app_base = sub {
    my $env = shift;

    my %env_sub =
        map  {($_ => $env->{$_})}
        grep {/^psgix\.woothee/}
        keys %{$env};

    return [200, ['Content-Type' => 'text/plain'], [Dumper \%env_sub]];
};

my $app = Plack::Middleware::Woothee->wrap($app_base);

test_psgi $app, sub {
    my $cb = shift;

    subtest iPhone => sub {
        my $res = $cb->(GET 'http://localhost/',
            'User-Agent' =>
                'Mozilla/5.0 (iPhone; U; CPU like Mac OS X; en) AppleWebKit/420+ '.
                '(KHTML, like Gecko) Version/3.0 Mobile/1C28 Safari/419.3',
        );
        is $res->code, 200;
        my $env_sub = eval $res->content;
        my $woothee = $env_sub->{'psgix.woothee'};
        is_deeply $woothee, {
          'category' => 'smartphone',
          'name'     => 'Safari',
          'os'       => 'iPhone',
          'vendor'   => 'Apple',
          'version'  => '3.0'
        };
    };

    subtest unknown => sub {
        my $res = $cb->(GET 'http://localhost/');
        is $res->code, 200;
        my $env_sub = eval $res->content;
        my $woothee = $env_sub->{'psgix.woothee'};
        is_deeply $woothee, {
            'category' => 'UNKNOWN',
            'name'     => 'UNKNOWN',
            'os'       => 'UNKNOWN',
            'vendor'   => 'UNKNOWN',
            'version'  => 'UNKNOWN'
        };
    };
};

done_testing;
