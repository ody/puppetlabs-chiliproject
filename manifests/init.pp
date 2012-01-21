# == Class: chiliproject
#
# Starting point for installing chiliproject.
#
# === Parameters
#
# Document parameters here.
#
# [*ntp_servers*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*enc_ntp_servers*]
#   Explanation of how this variable affects the funtion of this class and if it
#   has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should not be used in preference to class parameters  as of
#   Puppet 2.6.)
#
# === Examples
#
#  class { 'example_class':
#    ntp_servers => [ 'pool.ntp.org', 'ntp.local.company.com' ]
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2011 Your name here, unless otherwise noted.
#
class chiliproject {
  include chiliproject::data

  $packages = [ 'ruby', 'postgresql', 'postgresql-client', 'postgresql-server-dev-8.4', 'libmagick9-dev' ]
  package { $packages:
    ensure => present,
  }

  package { 'bundler':
    ensure   => present,
    require  => Package[$packages],
    provider => gem,
  }

  file { '/etc/postgresql/9.1/main/pg_hba.conf':
    ensure   => present,
    source   => 'puppet:///modules/chiliproject/pg_hba.conf',
    require  => Package['postgresql'],
  }

  exec { 'db_passwd':
    command  => 'psql --username postgres --command "alter user postgres with password" "puppet"',
    path     => '/usr/local/bin:/usr/bin:/bin:/opt/puppet/bin:/var/lib/gems/1.8/bin',
    require  => [Package["postgresql-client"], File['/etc/postgresql/9.1/main/pg_hba.conf']],
  }

  exec { 'db_init':
    command  => "psql --username postgres --command 'create database chiliproject'",
    path     => '/usr/local/bin:/usr/bin:/bin:/opt/puppet/bin:/var/lib/gems/1.8/bin',
    unless   => 'psql --username postgres --dbname chiliproject --command "\q"',
    require  => [Package['postgresql-client'], File['/etc/postgresql/9.1/main/pg_hba.conf']],
  }
}
