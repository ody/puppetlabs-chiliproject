class chiliproject::db(
  $db_user     = $chiliproject::data::db_user,
  $db_name     = $chiliproject::data::db_name,
  $db_password = $chiliproject::data::db_password,
  $db_encoding = $chiliproject::data::db_encoding,
) {

  Class['chiliproject'] -> Class['chiliproject::db'] ->
  Class['chiliproject::configuration']

  file { '/etc/postgresql/9.1/main/pg_hba.conf':
    ensure   => present,
    source   => 'puppet:///modules/chiliproject/pg_hba.conf',
    require  => Package['postgresql'],
  }

  exec { 'db_password':
    command  => "psql --username postgres --command 'create user ${db_user} with password ${db_password}'",
    path     => '/usr/local/bin:/usr/bin:/bin:/opt/puppet/bin:/var/lib/gems/1.8/bin',
    require  => [Package['postgresql-client'], File['/etc/postgresql/9.1/main/pg_hba.conf']],
  }

  exec { 'db_init':
    command  => "psql --username postgres --command 'create database chiliproject'",
    path     => '/usr/local/bin:/usr/bin:/bin:/opt/puppet/bin:/var/lib/gems/1.8/bin',
    unless   => 'psql --username postgres --dbname chiliproject --command "\q"',
    require  => [Package['postgresql-client'], File['/etc/postgresql/9.1/main/pg_hba.conf']],
  }
}
