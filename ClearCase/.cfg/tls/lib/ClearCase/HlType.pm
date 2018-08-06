package ClearCase::HlType;

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


# ============================================================================
# non exported package globals

# ============================================================================
# initialize package globals ( exported )

# ============================================================================
# initialize package globals ( not exported )

# ============================================================================
# file private lexicals


# ============================================================================
# Description

=head1 NAME

BrType - <short description>

=head1 SYNOPSIS

B<BrType.pm> [options]

=head1 DESCRIPTION

<long description>

=head1 USAGE

=head1 METHODS

=cut

# ============================================================================
# Preloaded methods go here.


# ===========================================================================

=head2 FUNCTION _init

DESCRIPTION

ARGUMENTS

 $self         the object

RETURN VALUE

=cut

sub _init {
   my $self = shift;


   $self->SUPER::_init( -type => 'hltype', @_ );
   return $self;
} # _init



# ===========================================================================

=head2 FUNCTION create

DESCRIPTION

ARGUMENTS

 $self         the object

RETURN VALUE

=cut

sub create {
   my $self = shift;

   ClearCase::mkhltype(
      -name    => $self->getName(),
      -vob     => $self->getVob()->getTag()
      );

   return $self;
} # create



# ============================================================================
# Autoload methods go after =cut, and are processed by the autosplit program.
#
# remeber to
#  require AutoLoader

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

Address bug reports and comments to: uwe@satthoff.eu.

When   sending   bug   reports,   please  provide   the   version   of
BrType.pm, the  version of Perl and  the name and version  of the
operating system you are using.


=head1 SEE ALSO

=cut
