# Class: chiliproject::deploy
#
#   Deploys and migrates the chiliproject that is stored in Git repo.
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class chiliproject::deploy(
  $path        = $chiliproject::data::path,
  $staging_dir = $chiliproject::data::staging_dir,
  $ignores     = $chiliproject::data::ignores
) {

  file { 'chiliproject_live_installation':
    ensure    => directory,
    path      => $path,
    source    => $staging_dir,
    recurse   => true,
    ignore    => $ignores,
    subscribe => Class['chiliproject::repo'],
  }
}
