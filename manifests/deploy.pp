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
  $ignores     = $chiliproject::data::ignores,
  $bin_path    = $chiliproject::data::bin_path,
  $language    = $chiliproject::data::language
) {

  file { 'chiliproject_live_installation':
    ensure    => directory,
    path      => $path,
    source    => $staging_dir,
    recurse   => true,
    ignore    => $ignores,
    subscribe => Class['chiliproject::repo'],
  }

  exec { 'chiliproject_bundle_install':
    command     => 'bundle install --without=test mysql mysql2 sqlite openid',
    path        => $bin_path,
    cwd         => $path,
    refreshonly => true,
    subscribe   => File['chiliproject_live_installation'],
  }

  exec { 'chiliproject_migrate':
    command     => 'bundle exec rake db:migrate',
    path        => $bin_path,
    environment => 'RAILS_ENV=production',
    cwd         => $path,
    refreshonly => true,
    subscribe   => Class['chiliproject::repo'],
    require     => Exec['chiliproject_bundle_install'],
  }

  exec { 'gen_session_store':
    command     => 'bundle exec rake generate_session_store',
    path        => $bin_path,
    environment => 'RAILS_ENV=production',
    cwd         => $path,
    creates     => "${path}/config/initializers/session_store.rb",
    require     => [ Class['chiliproject::repo'], Exec['chiliproject_bundle_install'] ],
  }

  exec { 'default_data':
    command     => 'bundle exec rake redmine:load_default_data',
    path        => $bin_path,
    environment => [ "REDMINE_LANG=${language}", 'RAILS_ENV=production' ],
    cwd         => $path,
    require     => [ Class['chiliproject::repo'], Exec['chiliproject_migrate'] ],
  }

}
