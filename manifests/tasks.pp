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
class chiliproject::tasks(
  $path        = $chiliproject::data::path,
  $bin_path    = $chiliproject::data::bin_path,
  $language    = $chiliproject::data::language
) {

  exec { 'chiliproject_bundle_install':
    command     => 'bundle install --without=test mysql mysql2 sqlite openid',
    path        => $bin_path,
    cwd         => $path,
    require     => Class['chiliproject::configuration'],
  }

  exec { 'chiliproject_migrate':
    command     => 'bundle exec rake db:migrate',
    path        => $bin_path,
    environment => 'RAILS_ENV=production',
    cwd         => $path,
    refreshonly => true,
    subscribe   => Class['chiliproject::configuration'],
    require     => Exec['chiliproject_bundle_install'],
  }

  exec { 'gen_session_store':
    command     => 'bundle exec rake generate_session_store',
    path        => $bin_path,
    environment => 'RAILS_ENV=production',
    cwd         => $path,
    creates     => "${path}/config/initializers/session_store.rb",
    require     => [ Class['chiliproject::configuration'], Exec['chiliproject_bundle_install'] ],
  }

  exec { 'default_data':
    command     => 'bundle exec rake redmine:load_default_data',
    path        => $bin_path,
    environment => [ "REDMINE_LANG=${language}", 'RAILS_ENV=production' ],
    cwd         => $path,
    require     => [ Class['chiliproject::repo'], Exec['chiliproject_migrate'] ],
  }
}
