# == Class: chiliproject::repo
#
# Clones the chiliproject Git repo.
#
# === Parameters
#
# [*user*]
#   User that the Chiliproject ticket tracker will run as.
#
# [*staging_dir*]
#   Where we pull the clean copy of the Chiliproject down to before we make
#   modifications to its default configurations.
#
# [*repo_source*]
#   The upstream location we obtain the Chiliproject code from.
#
# [*git_revision*]
#   The Chiliproject is stored in an upstream Git repository.
#
# === Examples
#
#  include 'chiliproject::repo'
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
