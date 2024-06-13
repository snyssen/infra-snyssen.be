<?php
$CONFIG = array(
  'debug' => false,
  'allow_local_remote_servers' => true,
  'allow_user_to_change_display_name' => false,
  'lost_password_link' => 'disabled',
  'app.mail.attachment-size-limit' => 5242880,
  'app.mail.imap.timeout' => 45,
  'app.mail.smtp.timeout' => 20,
  'app.mail.sieve.timeout' => 20,
  'htaccess.RewriteBase' => '/',
  'memcache.local' => '\\OC\\Memcache\\APCu',
  'apps_paths' =>
  array(
    0 =>
    array(
      'path' => '/var/www/html/apps',
      'url' => '/apps',
      'writable' => false,
    ),
    1 =>
    array(
      'path' => '/var/www/html/custom_apps',
      'url' => '/custom_apps',
      'writable' => true,
    ),
  ),
  'memcache.distributed' => '\\OC\\Memcache\\Redis',
  'memcache.locking' => '\\OC\\Memcache\\Redis',
  'redis' =>
  array(
    'host' => 'nextcloud_redis',
    'password' => '',
    'port' => 6379,
  ),
  'overwriteprotocol' => 'https',
  'passwordsalt' => '{{ nextcloud__passwordsalt }}',
  'secret' => '{{ nextcloud__secret }} ',
  'trusted_domains' =>
  array(
    0 => 'localhost',
    1 => 'cloud.{{ ansible_fqdn }}',
  ),
  'trusted_proxies' =>
  array(
    0 => '172.18.0.0/24',
  ),
  'datadirectory' => '/var/www/html/data',
  'dbtype' => 'pgsql',
  'version' => '29.0.1.1',
  'overwrite.cli.url' => 'https://cloud.{{ ansible_fqdn }}',
  'dbname' => 'nextcloud',
  'dbhost' => 'postgres',
  'dbport' => '',
  'dbtableprefix' => '',
  'dbuser' => 'nextcloud',
  'dbpassword' => '{{ nextcloud__postgres_password }}',
  'installed' => true,
  'instanceid' => '{{ nextcloud__instanceid }}',
  'has_rebuilt_cache' => true,
  'maintenance' => false,
  'theme' => '',
  'loglevel' => 1,
  'log_type' => 'file',
  'logfile' => '/var/logs/nextcloud.log',
  'log_type_audit' => 'file',
  'logfile_audit' => '/var/logs/audit.log',
  'mail_smtpmode' => 'smtp',
  'mail_smtpsecure' => 'tls',
  'mail_sendmailmode' => 'smtp',
  'mail_from_address' => 'nextcloud',
  'mail_domain' => '{{ ansible_fqdn }}',
  'mail_smtpauthtype' => 'LOGIN',
  'mail_smtpauth' => 1,
  'mail_smtphost' => '{{ vault_smtp__host }}',
  'mail_smtpport' => '{{ smtp__port }}',
  'mail_smtpname' => '{{ smtp__user }}',
  'mail_smtppassword' => '{{ smtp__pass }}',
  'maintenance_window_start' => 1,
  'ldapProviderFactory' => 'OCA\\User_LDAP\\LDAPProviderFactory',
  'user_oidc' => [
    'auto_provision' => false,
  ],
);
