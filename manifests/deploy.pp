# == Class: chiliproject::deploy
#
# Deploys and migrates the chiliproject that is stored in a staged Git repo.
#
# === Parameters
#
# [*user*]
#   User that the Chiliproject ticket tracker will run as.
#
# [*path*]
#   Location for the functional copy of Chiliproject on the file system.
#
# [*port*]
#   HTTP port that our Chiliproject instance will run on.
#
# [*pid_file*]
#   Stored PID of a running passenger process that is service the Chiliproject
#   instance.
#
# === Examples
#
#  include chiliproject::deploy
#
# === Authors
#
# Daniel Sauble <djsauble@puppetlabs.com>
# Cody Herriges <cody@puppetlabs.com>
#
# === Copyright
#
# Copyright 2011 Puppet Labs
#
class chiliproject::deploy(
  $user     = $chiliproject::data::user,
  $path     = $chiliproject::data::path,
  $port     = $chiliproject::data::port,
  $pid_file = "${path}/tmp/pids/passenger.${port}.pid",
) {

  exec { 'chiliproject_bundle_install':
    command     => 'bundle install --without=test mysql mysql2 sqlite openid',
    path        => '/usr/local/bin:/usr/bin:/bin:/opt/puppet/bin:/var/lib/gems/1.8/bin',
    cwd         => $path,
    refreshonly => true,
    subscribe   => Class['chiliproject::repo'],
  }

  exec { 'chiliproject_migrate':
    command     => 'bundle exec rake db:migrate',
    path        => '/usr/local/bin:/usr/bin:/bin:/opt/puppet/bin:/var/lib/gems/1.8/bin',
    environment => 'RAILS_ENV=production',
    cwd         => $path,
    refreshonly => true,
    subscribe   => Class['chiliproject::repo'],
    require     => Exec['gen_session_store'],
  }

  exec { 'gen_session_store':
    command     => 'bundle exec rake generate_session_store',
    path        => '/usr/local/bin:/usr/bin:/bin:/opt/puppet/bin:/var/lib/gems/1.8/bin',
    environment => 'RAILS_ENV=production',
    cwd         => $path,
    creates     => "${path}/config/initializers/session_store.rb",
    require     => Exec['chiliproject_bundle_install']
  }

  exec { 'default_data':
    command     => 'bundle exec rake redmine:load_default_data',
    path        => '/usr/local/bin:/usr/bin:/bin:/opt/puppet/bin:/var/lib/gems/1.8/bin',
    environment => ['REDMINE_LANG=en', 'RAILS_ENV=production'],
    cwd         => $path,
    require     => Exec['chiliproject_migrate']
  }

  file { "${path}/vendor":
    ensure  => directory,
    recurse => true,
    source  => 'puppet:///modules/chiliproject/vendor'
  }

  exec { 'plugins':
    command     => 'bundle exec rake db:migrate:plugins',
    path        => '/usr/local/bin:/usr/bin:/bin:/opt/puppet/bin:/var/lib/gems/1.8/bin',
    environment => 'RAILS_ENV=production',
    cwd         => $path,
    require     => File["${path}/vendor"]
  }

  package { 'passenger':
    provider    => 'gem',
    name        => 'passenger',
    ensure      => 'present'
  }

  exec { 'passenger':
    command     => "passenger start --port ${port} --pid-file ${pid_file} --user ${user} --daemonize",
    creates     => $pid_file,
    path        => '/usr/local/bin:/usr/bin:/bin:/opt/puppet/bin:/var/lib/gems/1.8/bin',
    environment => 'RAILS_ENV=production',
    cwd         => $path,
    require     => [File["${path}/vendor"], Package['passenger']]
  }
}
