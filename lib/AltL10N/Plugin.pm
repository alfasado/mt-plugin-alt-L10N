package AltL10N::Plugin;

use strict;

sub _pre_run {
    my $app = MT->instance();
    my $plugin = MT->component( 'AltL10N' );
    require File::Spec;
    require MT::FileMgr;
    my $fmgr = MT::FileMgr->new( 'Local' ) or die MT::FileMgr->errstr;
    my $lh = MT->language_handle;
    my $language = ref $lh;
    $language =~ s/^.*::(.*$)/$1/;
    my $l10n;
    if ( my $blog = $app->blog ) {
        $l10n = File::Spec->catfile( $plugin->path, 'L10N', $blog->id, "$language.pm" );
        if (! $fmgr->exists( $l10n ) ) {
            $l10n = undef;
        }
    }
    if (! $l10n ) {
        $l10n = File::Spec->catfile( $plugin->path, 'L10N', "$language.pm" );
    }
    if ( $fmgr->exists( $l10n ) ) {
        my $data = $fmgr->get_data( $l10n );
        eval( $data );
    }
    return 1;
}

1;