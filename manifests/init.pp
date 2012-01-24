# == Class: chiliproject
#
# Starting point for installing chiliproject.  The current state of this module
# makes assumptions about platform, Ubuntu Lucid 10.04 or Debian Squeeze.  More
# platforms coming soon with added pluggability.
#
# === Variables
#
# [*packages*]
#   An array of package dependancies for Chiliproject to actually install.
#   Haven't made this a configurable via a parameter since this module is
#   currently rather restrictive in platform.
#
# === Examples
#
# include chiliproject
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
class chiliproject {
  include chiliproject::data

  $packages = [ 'ruby', 'postgresql', 'postgresql-client',
                'postgresql-server-dev-8.4', 'libmagick9-dev' ]
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
