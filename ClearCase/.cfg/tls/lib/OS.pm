package OS;

use strict;
use Carp;
use Log;

sub BEGIN {
   require Transaction;
   require OS::Common::Config;
   require OS::Common::OsTool;
}

BEGIN {
   use vars qw($VERSION @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS);

   require Exporter;

   @ISA = qw(Exporter);

   @EXPORT = qw(
   );
   @EXPORT_OK = qw(
   );
   %EXPORT_TAGS = (
   # TAG1 => [...],
   );
   $VERSION = '0.01';

};

sub AUTOLOAD {
    use vars qw( $AUTOLOAD );

    ( my $method = $AUTOLOAD ) =~ s/.*:://;

    if( $method =~ m/^Init(\S+)$/ ) { # request to create object of package method = InitPackage
	my $package = 'OS::' . $1;
	eval "require $package";
	Die( [ "require of package $package failed." ] ) if $@;

	no strict 'refs';
	no strict 'subs';
	my $func = <<EOF
	    sub OS::$method {
		return $package->new( \@_ );
	}
EOF
;
	eval( "$func" );
	Die( [$func, $@ ] ) if $@;
	goto &$AUTOLOAD;
    } else {
	my $package = "OS::Command::$method";
	eval "require $package";
	Die( [ "require of package $package failed." ] ) if $@;

	no strict 'refs';
	no strict 'subs';
	my $func = <<EOF
	    sub OS::$method { # method is a command of the OS interface
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
    return OS::Common::OsTool::getErrors();
}

sub getWarnings {
    return OS::Common::OsTool::getWarnings();
}

sub getOutput {
    return OS::Common::OsTool::getOutput();
}

sub getOutputLine {
    return OS::Common::OsTool::getOutputLine();
}

sub getRC {
    return OS::Common::OsTool::getRC();
}

sub disableErrorOut {
    ClearCase::Common::Cleartool::disableErrorOut();
    return;
}

sub enableErrorOut {
    OS::Common::OsTool::enableErrorOut();
    return;
}

sub disableDieOnErrors {
    OS::Common::OsTool::disableDieOnErrors();
    return;
}

sub enableDieOnErrors {
    OS::Common::OsTool::enableDieOnErrors();
    return;
}

1;

__END__

=head1 EXAMPLES

=head1 AUTHOR INFORMATION

 Copyright (C) 2010   Uwe Satthoff 

=head1 BUGS

 Address bug reports and comments to:
	uwe@satthoff.eu

=head1 SEE ALSO

=cut

