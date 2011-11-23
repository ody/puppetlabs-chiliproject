# Class: chiliproject
#
#   Starting point for installing chiliproject.
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class chiliproject::packages(
  $packages = $chiliproject::data::packages
) {
  package { $packages:
    ensure => present,
    require => Class['chiliproject'],
  }

  package { 'bundler':
    ensure   => present,
    require  => Package[$packages],
    provider => gem,
  }
}
