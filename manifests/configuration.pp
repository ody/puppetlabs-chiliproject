# == Class: chiliproject::configuration
#
# Configuration files for a chiliproject instance.
#
# === Parameters
#
# [*user*]
#   User that the Chiliproject ticket tracker will run as.
#
# [*path*]
#   Location for the functional copy of Chiliproject on the file system.
#
# [*db_adapter*]
#   Our choice adapter for rails to use to communicate with our backend
#   it isn't currently a gcood idea to actually change this until the bundle
#   install in the deploy class it dynamically selecting what not to install.
#   It currently hard setting the exclusion of sqlite and mysql.
#
# [*db_name*]
#   The name of our Chiliproject database.
#
# [*db_host*]
#   The machine our Chiliproject instance communicates with for database
#   information.
#
# [*db_port*]
#   The port that our Chiliporject database is running on.
#
# [*db_user*]
#    User we use to authenticate to our Chiliproject database.
#
# [*db_password*]
#    User password used to authenticate to our Chiliproject database.
#
# [*db_encoding*]
#    Database encoding.  This maybe important depending on which language you
#    are going to use.  Where defaulting to utf8 so you should be pretty safe.
#
# [*email_tls*]
#    We really don't want you to accidentally pass a sensitive password over the
#    wire unencrypted so we turn on tls by default for email.
#
# [*email_starttls*]
#    If we use the startls method of generating the secure connection or the old
#    school SSL style.  Most things are capable of starttls now a days so were
#    going to default to true.
#
# [*email_port*]
#   Pretty standard SMTP port for delivering email.
#
# [*email_auth*]
#   The type auth that rails will use to authenticate you to a mail server.
#   :plain being the most likely to function.
#
# [*email_address*]
#   The email address you will be sending Chiliproject email from.  This is a
#   a required parameter since it is unfeasible for me@example.com to actually
#   work as a default value in anyone's infrastrucure.
#
# [*email_domain*]
#   The hostname we will use as and SMTP server for delivering out going mail.
#
# [*email_user_name*]
#   User name you will authenticate to your SMTP server as.  In the case of a
#   Google email this will likely be the same as email_address.
#
# [*email_password*]
#   The plain text representation of the password needed to authenticate to SMTP
#   server.  You will likely want to actually hide this away and do a data look
#   up in something like hiera.
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
  $email_tls       = $chiliproject::data::email_tls,
  $email_starttls  = $chiliproject::data::email_starttls,
  $email_port      = $chiliproject::data::email_port,
  $email_auth      = $chiliproject::data::email_auth,
  $email_address,
  $email_domain,
  $email_user_name,
  $email_password,
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
