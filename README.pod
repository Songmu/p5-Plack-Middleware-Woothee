package Plack::Middleware::Woothee;
use 5.008_001;
use strict;
use warnings;

our $VERSION = '0.01';

use parent 'Plack::Middleware';
use Woothee;

sub call {
    my($self, $env) = @_;

    $env->{'psgix.woothee'} = Woothee->parse($env->{HTTP_USER_AGENT});
    $self->app->($env);
}

1;
__END__

=head1 NAME

Plack::Middleware::Woothee - Set woothee information based on User-Agent

=head1 VERSION

This document describes Plack::Middleware::Woothee version 0.01.

=head1 SYNOPSIS

    use Plack::Middleware::Woothee;
    use Plack::Builder;

    my $app = sub {
        my $env = shift;
        # automatically assigned by Plack::Middleware::Woothee
        my $woothee = $env->{'psgix.woothee'};
        ...
    };
    builder {
        enable 'Woothee';
        $app;
    };

=head1 DESCRIPTION

This middleware get woothee information based on User-Agent and assign
this to `$env->{'psgix.woothee'}`.

You can use this information in your application.

=head1 DEPENDENCIES

Perl 5.8.1 or later.

=head1 BUGS

All complex software has bugs lurking in it, and this module is no
exception. If you find a bug please either email me, or add the bug
to cpan-RT.

=head1 SEE ALSO

L<perl> L<Woothee>

=head1 AUTHOR

Masayuki Matsuki E<lt>y.songmu@gmail.comE<gt>

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2013, Masayuki Matsuki. All rights reserved.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
