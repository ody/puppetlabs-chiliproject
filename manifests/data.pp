# == Class: chiliproject::data
#
# Default configuration data used by the chiliproject module to configure
# various aspects of the deployment.  All of these values should be overrideable
# through the use of parameterized classes.
#
# === Variables
#
# [*user*]
#   User that the Chiliproject ticket tracker will default to.
#
# [*path*]
#   Location for the functional copy of Chiliproject on the file system.
#
# [*repo_source*]
#   The upstream location we obtain the Chiliproject code from.
#
# [*staging_dir*]
#   Where we pull the clean copy of the Chiliproject down to before we make
#   modifications to its default configurations.
#
# [*port*]
#   Default HTTP port that our Chiliproject instance will run on.
#
# [*git_revision*]
#   The Chiliproject is stored in an upstream Git repository, we default to
#   HEAD of master.
#
# [*language*]
#   English is the default here since that is the language we speek.
#
# [*ignores*]
#   When we sync out from our repository staging area to the functional location
#   there is a set of files we don't want to have a resource created for, for
#   various reasons.
#
# [*db_adapter*]
#   Our choice adapter for rails to use to communicate with our backend database.
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
# === Examples
#
# include chiliproject::data
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
class chiliproject::data {
  $user            = 'puppet'
  $path            = '/var/www/html/chiliproject'
  $repo_source     = 'https://github.com/chiliproject/chiliproject.git'
  $staging_dir     = '/var/opt/lib/pe-puppet/staging'
  $port            = '3000'
  $git_revision    = 'master'
  $language        = 'en'
  $ignores         = [ '.git', 'database.yml', 'configuration.yml' ]
  $db_adapter      = 'postgresql'
  $db_name         = 'chiliproject'
  $db_host         = 'localhost'
  $db_port         = '5432'
  $db_user         = 'chiliproject'
  $db_password     = 'my_password'
  $db_encoding     = 'utf8'
  $email_tls       = 'true'
  $email_starttls  = 'true'
  $email_port      = '587'
  $email_auth      = ':plain'
}
