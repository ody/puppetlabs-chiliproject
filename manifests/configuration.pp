# == Class: chiliproject::configuration
#
# Configuration files for a chiliproject instance.
#
# === Parameters
#
# [*ntp_servers*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
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
#  class { 'chiliproject::configuration':
#    email_address   => 'me@example.com',
#    email_domain    => 'smtp.example.com',
#    email_user_name => 'me',
#    email_password  => 'reallysecret',
#  }
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
class chiliproject::configuration(
  $user            = $chiliproject::data::user,
  $path            = $chiliproject::data::path,
  $db_adapter      = $chiliproject::data::db_adapter,
  $db_name         = $chiliproject::data::db_name,
  $db_host         = $chiliproject::data::db_host,
  $db_port         = $chiliproject::data::db_port,
  $db_user         = $chiliproject::data::db_user,
  $db_password     = $chiliproject::data::db_password,
  $db_encoding     = $chiliproject::data::db_encoding,
  $db_socket       = $chiliproject::data::db_socket,
  $email_tls       = $chiliproject::data::email_tls,
  $email_starttls  = $chiliproject::data::email_starttls,
  $email_port      = $chiliproject::data::email_port,
  $email_auth      = $chiliproject::data::email_auth,
  $email_address,
  $email_domain,
  $email_user_name,
  $email_password
) {

  file { 'chiliproject_database_config':
    path    => "${path}/config/database.yml",
    owner   => $user,
    group   => $user,
    content => template('chiliproject/config/database.yml.erb'),
    require => Class['chiliproject::repo'],
    before  => Class['chiliproject::deploy'],
  }

  file { 'chiliproject_configuration':
    path    => "${path}/config/configuration.yml",
    owner   => $user,
    group   => $user,
    content => template('chiliproject/config/configuration.yml.erb'),
    require => Class['chiliproject::repo'],
    before  => Class['chiliproject::deploy'],
  }

}
