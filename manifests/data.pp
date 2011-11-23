class chiliproject::data {
  $path         = '/var/www/html/chiliproject'
  $repo_source  = 'https://github.com/chiliproject/chiliproject.git'
  $staging_dir  = '/var/opt/lib/pe-puppet/staging'
  $packages     = [ 'ruby', 'postgresql-server-dev-8.4', 'libmagick9-dev' ]
  $git_revision = present
  $language     = 'en'
  $ignores      = [ '.git*', '.hg*', 'database.yml', 'configuration.yml' ]
  $bin_path     = '/usr/bin:/bin:/opt/puppet/bin:/var/lib/gems/1.8/bin'
  $db_adapter   = 'postgresql'
  $db_name      = 'chiliproject'
  $db_host      = 'localhost'
  $db_port      = '5432'
  $db_user      = 'chiliproject'
  $db_password  = 'my_password'
  $db_encoding  = 'utf8'
}
