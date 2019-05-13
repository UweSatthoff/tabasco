package ClearCase::Command::mkelem;

use strict;
use Carp;
use Log;

sub BEGIN {
   use vars qw($VERSION @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS %DATA);
   $VERSION = '0.01';
   require Exporter;
   require Transaction::Command;

   @ISA = qw(Exporter Transaction::Command);

   @EXPORT = qw(
   );
   @EXPORT_OK = qw(
   );
   %EXPORT_TAGS = (
      # TAG1 => [...],
   );

   %DATA = (
       ElType      => undef,
       Comment     => undef,
       NoCheckout  => undef,
       Argv => undef
   );

   Data::init(
      PACKAGE  => __PACKAGE__,
      SUPER    => 'Transaction::Command'
      );

} # sub BEGIN()



sub new {
   my $proto = shift;
   my $class = ref $proto || $proto;

   my ( $transaction, $argv, $eltype, $comment, $noco, @other ) =
      $class->rearrange(
         [ qw( TRANSACTION ARGV ELTYPE COMMENT NOCHECKOUT ) ],
         @_ );
   confess join( ' ', @other ) if @other;

   my $self  = $class->SUPER::new( $transaction );
   bless $self, $class;

   $self->setElType( $eltype );
   $self->setComment( $comment );
   $self->setNoCheckout( $noco );
   $self->setArgv($argv);

   return $self;
}

sub do_execute {
   my $self = shift;
   my @options = ();

   if ( defined $self->getComment() )
   {
      push @options, ' -c "' . $self->getComment() . '"';
   }
   else
   {
      push @options, ' -nc';
   }

   push @options, '-eltype ' . $self->getElType()  if $self->getElType();
   push @options, '-nco' if $self->getNoCheckout();

   ClearCase::Common::Cleartool::mkelem(
      @options,
      $self->getArgv() );
}

sub do_commit {
   my $self = shift;
   ClearCase::Common::Cleartool::checkin(
      '-nc',
      '-ident',
      $self->getArgv() )i unless( $self->getNoCheckout() );
}

sub do_rollback {
   my $self = shift;
   ClearCase::Common::Cleartool::checkin(
      '-nc',
      '-ident',
      $self->getArgv() ) unless( $self->getNoCheckout() );

   ClearCase::Common::Cleartool::rmelem(
      '-f',
      $self->getArgv() );

}

1;

__END__

=head1 FILES

=head1 EXTERNAL INFLUENCES

=head1 EXAMPLES

=head1 WARNINGS

=head1 AUTHOR INFORMATION

 Copyright (C) 2007  Uwe Satthoff

=head1 CREDITS

=head1 BUGS

Address bug reports and comments to: satthoff@icloud.com


=head1 SEE ALSO

=cut
