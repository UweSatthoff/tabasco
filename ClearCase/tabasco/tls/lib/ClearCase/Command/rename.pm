package ClearCase::Command::rename;

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
       NewName  => undef,
       OldName  => undef,
       Acquire  => undef
   );

   Data::init(
      PACKAGE  => __PACKAGE__,
      SUPER    => 'Transaction::Command'
      );

} # sub BEGIN()

sub new {
   my $proto = shift;
   my $class = ref $proto || $proto;

   my ( $transaction, $newName, $oldName, $acquire, @other ) =
      $class->rearrange(
         [ qw( TRANSACTION NEWNAME OLDNAME ACQUIRE ) ],
         @_ );
   confess join( ' ', @other ) if @other;

   my $self  = $class->SUPER::new( $transaction );
   bless $self, $class;

   $self->setNewName( $newName );
   $self->setOldName( $oldName );
   $self->setAcquire( $acquire );

   return $self;
}

sub do_execute {
    my $self = shift;
    my @options = ();
    push @options, '-acquire' if $self->getAcquire();
    clearcase::Common::Cleartool::rename( @options, $self->getOldName(), $self->getNewName() );
}

sub do_commit {
   my $self = shift;
}

sub do_rollback {
    my $self = shift;
    my @options = ();
    push @options, '-acquire' if $self->getAcquire();
    ClearCase::Common::Cleartool::rename( @options, $self->getNewName(), $self->getOldName() );
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
