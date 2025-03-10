<?php
$CONFIG = array (
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
  'overwrite.cli.url' => 'https://cloud.{{ ansible_fqdn }}',
  'instanceid' => '{{ nextcloud__instanceid }}',
  'memcache.distributed' => '\\OC\\Memcache\\Redis',
  'memcache.locking' => '\\OC\\Memcache\\Redis',
  'redis' =>
  array(
    'host' => 'nextcloud_redis',
    'password' => '',
    'port' => 6379,
  ),
  'dbtype' => 'pgsql',
  'dbname' => 'nextcloud',
  'dbhost' => 'postgres',
  'dbport' => '',
  'dbtableprefix' => '',
  'dbuser' => 'nextcloud',
  'dbpassword' => '{{ nextcloud__postgres_password }}',
  'mail_smtpmode' => 'smtp',
  'mail_smtpsecure' => 'tls',
  'mail_sendmailmode' => 'smtp',
  'mail_from_address' => 'nextcloud',
  'mail_domain' => '{{ ansible_fqdn }}',
  'mail_smtpauthtype' => 'LOGIN',
  'mail_smtpauth' => 1,
  'mail_smtphost' => '{{ smtp__host }}',
  'mail_smtpport' => '{{ smtp__port }}',
  'mail_smtpname' => '{{ smtp__user }}',
  'mail_smtppassword' => '{{ smtp__pass }}',
);
