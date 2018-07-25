package ClearCase::Common::MetaObject;

use strict;
use Carp;

use Log;

sub BEGIN {
   use vars qw($VERSION @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS %DATA);
   $VERSION = '0.01';
   require Exporter;

   @ISA = qw(Exporter Data);

   @EXPORT = qw(
   );
   @EXPORT_OK = qw(
   );
   %EXPORT_TAGS = (
      # TAG1 => [...],
   );

   %DATA = (
       Name => undef,
       Type => undef,
       Vob => undef,
       FullName => undef,
       Exists => undef
      );

   require Data;
   Data::init(
      PACKAGE  => __PACKAGE__,
      SUPER    => undef
      );

} # sub BEGIN()

my @knownTypes = qw/ brtype lbtype attype hltype trtype eltype /;

sub new {
   my $proto = shift;
   my $class = ref( $proto ) || $proto;
   my $self  = {};
   bless( $self, $class );

   return $self->_init( @_ );
} # new

sub _init {
   my $self = shift;

   my ( $type, $name, $vob, @other ) = $self->rearrange(
      [ 'TYPE', 'NAME', 'VOB' ],
      @_ );

   # the type and vob arguments will only be used/checked, if the appropriate information is not encoded in the name argument
   my $typeName = '';
   my $vobTag = '';
   
   if( $name =~ m/^\s*(\S+):(\S+)\@(\S+).*$/ ) {
       $typeName = $1;
       $name = $2;
       $vobTag = $3;
   } elsif( $name =~ m/^\s*(\S+)\@(\S+).*$/ ) {
       Die( [ '', 'Wrong object initialization in ' .  __PACKAGE__ . ". Missing type specification.", '' ] ) unless( $type );
       $typeName = $type;
       $name = $1;
       $vobTag = $2;
   } elsif( $name !~ m/:|\@/ ) {
       Die( [ '', 'Wrong object initialization in ' .  __PACKAGE__ . ". Missing type specification.", '' ] ) unless( $type );
       Die( [ '', 'Wrong object initialization in ' .  __PACKAGE__ . ". Missing Vob specification.", '' ] ) unless( $vob );
       $typeName = $type;
       $vobTag = $vob->getTag();
   } else {
       Die( [ '', 'Wrong object initialization in ' .  __PACKAGE__ . " with name = $name", "Possibly missing type and/or Vob specification.", '' ] );
   }

   Die( [ '', 'Wrong object initialization in ' .  __PACKAGE__ . ". Unknown object type = $typeName.", '' ] ) unless( grep m/^${typeName}$/, @knownTypes );
   unless( $ClearCase::Common::Config::myHost->getRegion()->getVob( $vobTag ) and $ClearCase::Common::Config::myHost->getRegion()->getVob( $vobTag )->exists() ) {
       Die( [ '', 'Wrong object initialization in ' .  __PACKAGE__ . ". Specified Vob does not exist. Vob tag = $vobTag.", '' ] );
   }

   $self->setType( $typeName );
   $self->setName( $name );
   $self->setVob( $ClearCase::Common::Config::myHost->getRegion()->getVob( $vobTag ) );
   $self->setFullName( $typeName . ':' . $name . "\@$vobTag" );
   return $self;
}

sub exists {
    my $self = shift;

    unless( defined $self->getExists() ) {
	ClearCase::disableErrorOut();
	ClearCase::disableDieOnErrors();
	ClearCase::describe(
	    -argv => $self->getFullName(),
	    -short    => 1
	    );
	my $ex = ( ClearCase::getRC() == 0 );
	ClearCase::enableErrorOut();
	ClearCase::enableDieOnErrors();
	return $self->setExists( $ex );
    } else {
	return $self->getExists();
    }
}

1;

__END__

=head1 FILES

=head1 EXTERNAL INFLUENCES

=head1 EXAMPLES

=head1 WARNINGS

=head1 AUTHOR INFORMATION

 Copyright (C) 2006 Uwe Satthoff

=head1 CREDITS

=head1 BUGS

Address bug reports and comments to: uwe@satthoff.eu

=head1 SEE ALSO

=cut
