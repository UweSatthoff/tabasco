package ClearCase::BrType;

# ============================================================================
# standard modules
use strict;                   # restrict unsafe constructs
use Carp;

sub BEGIN {
   # =========================================================================
   # global definitions
   use vars qw($VERSION @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS %DATA);

   # set the version for version checking. All on one line !!!!!
   $VERSION = '0.01';

   # =========================================================================
   # required Moduls
   require Exporter;          # implements default import method for modules
   require ClearCase::Common::MetaObject;
   require Data;

   # =========================================================================
   #
   @ISA = qw(Exporter ClearCase::Common::MetaObject);

   # =========================================================================
   # Exporter

   # symbols to export by default
   # Note: do not export names by default without a very good reason. Use
   # EXPORT_OK instead.  Do not simply export all your public
   # functions/methods/constants.
   @EXPORT = qw(
   );

   # symbols to export on request.
   @EXPORT_OK = qw(
   );

   # define names for sets of symbols.
   %EXPORT_TAGS = (
      # TAG1 => [...],
   );

   %DATA = (
	   );

   Data::init(
      PACKAGE     => __PACKAGE__,
      SUPER       => 'ClearCase::Common::MetaObject'
      );


} # sub BEGIN()

sub _init {
   my $self = shift;

   $self->SUPER::_init( -type => 'brtype', @_ );
   return $self;
} # _init


sub create {
    my $self = shift;

    my ( $pbranch, $comment, @other ) = $self->rearrange(
	[ 'PBRANCH', 'COMMENT' ],
	@_ );
    unless( $pbranch ) {
	$pbranch = 0;
    }

    my $adminMode = 0;
    $adminMode = 1 if( $self->getVob()->getClientVobs() or $self->getVob()->getMyAdminVob() );
    ClearCase::mkbrtype(
	-name    => $self->getName(),
	-pbranch => $pbranch,
	-global  => $adminMode,
	-acquire => $adminMode,
	-vob     => $self->getAdminVob()->getTag(),
	-comment => $comment
	);

    return $self;
}


1;

__END__

=head1 FILES

=head1 EXTERNAL INFLUENCES

=head1 EXAMPLES

=head1 WARNINGS

=head1 AUTHOR INFORMATION

 Copyright (C) 2007   Uwe Satthoff

=head1 CREDITS

=head1 BUGS

Address bug reports and comments to: satthoff@icloud.com.

When   sending   bug   reports,   please  provide   the   version   of
BrType.pm, the  version of Perl and  the name and version  of the
operating system you are using.


=head1 SEE ALSO

=cut
