package ClearCase;

use strict;
use Carp;

sub BEGIN {
   require Transaction;
   require ClearCase::Common::Config;
   require ClearCase::Common::Cleartool;
}

use Log;

my $CC_VERSION    = undef;

# ============================================================================
# Description

=head1 NAME

ClearCase - <short description>

=head1 SYNOPSIS

B<ClearCase.pm> [options]

=head1 DESCRIPTION

<long description>

=head1 USAGE

=head1 METHODS

=cut


sub AUTOLOAD {
    use vars qw( $AUTOLOAD );

    ( my $method = $AUTOLOAD ) =~ s/.*:://;

    if( $method =~ m/^Init(\S+)$/ ) { # request to create object of package method = InitPackage
	my $package = 'ClearCase::' . $1;
	eval "require $package";
	Die( [ "require of package $package failed." ] ) if $@;

	no strict 'refs';
	no strict 'subs';
	my $func = <<EOF
	    sub ClearCase::$method {
		return $package->new( \@_ );
	}
EOF
;
	eval( "$func" );
	Die( [$func, $@ ] ) if $@;
	goto &$AUTOLOAD;
    } else {
	my $package = "ClearCase::Command::$method";
	eval "require $package";
	Die( [ "require of package $package failed." ] ) if $@;

	no strict 'refs';
	no strict 'subs';
	my $func = <<EOF
	    sub ClearCase::$method { # method is a command of the ClearCase interface
		my \$action = $package->new( -transaction => Transaction::getTransaction(), \@_  );
		\$action->execute();
	}
EOF
;
	eval( "$func" );
	Die( [$func, $@ ] ) if $@;
	goto &$AUTOLOAD;
    }
    

} # AUTOLOAD

sub getErrors {
    return ClearCase::Common::Cleartool::getErrors();
}

sub getWarnings {
    return ClearCase::Common::Cleartool::getWarnings();
}

sub getOutput {
    return ClearCase::Common::Cleartool::getOutput();
}

sub getOutputLine {
    return ClearCase::Common::Cleartool::getOutputLine();
}

sub getRC {
    return ClearCase::Common::Cleartool::getRC();
}

sub disableErrorOut {
    ClearCase::Common::Cleartool::disableErrorOut();
    return;
}

sub enableErrorOut {
    ClearCase::Common::Cleartool::enableErrorOut();
    return;
}

sub disableDieOnErrors {
    ClearCase::Common::Cleartool::disableDieOnErrors();
    return;
}

sub enableDieOnErrors {
    ClearCase::Common::Cleartool::enableDieOnErrors();
    return;
}

1;

__END__

=head1 EXAMPLES

=head1 AUTHOR INFORMATION

 Copyright (C) 2006 Uwe Satthoff

=head1 BUGS

 Address bug reports and comments to:
   uwe@satthoff.eu

=head1 SEE ALSO

=cut
