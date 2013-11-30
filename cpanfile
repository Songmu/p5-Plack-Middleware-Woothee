requires 'Plack', '1';
requires 'Woothee';
requires 'parent';
requires 'perl', '5.008001';

on build => sub {
    requires 'HTTP::Request::Common';
    requires 'Test::More', '0.98';
    requires 'Test::Requires', '0.06';
};
