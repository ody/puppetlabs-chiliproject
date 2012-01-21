# == Class: chiliproject::repo
#
# Clones the chiliproject Git repo.
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
class chiliproject::repo(
  $user         = $chiliproject::data::user,
  $staging_dir  = $chiliproject::data::staging_dir,
  $repo_source  = $chiliproject::data::repo_source,
  $git_revision = $chiliproject::data::git_revision
) {
  file { $staging_dir:
    ensure => directory,
    owner  => $user,
    group  => $user,
    mode   => '0600',
  }

  vcsrepo { 'chiliproject_repo':
    path     => $staging_dir,
    owner    => $user,
    group    => $user,
    ensure   => present,
    force    => true,
    source   => $repo_source,
    revision => $git_revision,
    provider => 'git',
    require  => Class["chiliproject"],
  }

  # Needed because the rake db:migrate command is returning 1 instead of 0
  file { "${staging_dir}/log/production.log":
    ensure  => present,
    mode    => '0664',
    require => Vcsrepo['chiliproject_repo'],
  }
}
