# == Class: chiliproject
#
# Starting point for installing chiliproject.  The current state of this module
# makes assumptions about platform, Ubuntu Lucid 10.04 or Debian Squeeze.  More
# platforms coming soon with added pluggability.
#
# === Parameters
#
# [*packages*]
#   An array of package dependancies for Chiliproject to actually install.
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
class chiliproject(
  $packages = [ 'ruby', 'postgresql', 'postgresql-client',
                'postgresql-server-dev-8.4', 'libmagick9-dev' ],
) {
  include chiliproject::data

  package { $packages:
    ensure => present,
  }

  package { 'bundler':
    ensure   => present,
    require  => Package[$packages],
    provider => gem,
  }
}
