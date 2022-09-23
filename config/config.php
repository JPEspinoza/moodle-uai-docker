<?php

unset($CFG);  // Ignore this line
global $CFG;  // This is necessary here for PHPUnit execution
$CFG = new stdClass();

# db config
$CFG->dbtype    = 'mariadb';
$CFG->dblibrary = 'native';
$CFG->dbhost    = 'localhost:3306';
$CFG->dbname    = 'moodle';
$CFG->dbuser    = 'moodle';
$CFG->dbpass    = 'moodle';
$CFG->prefix    = 'mdl_';
$CFG->dboptions = array(
    'dbpersist' => true,
    'dbcollation' => 'utf8mb4_unicode_ci',
);

$CFG->dataroot  = '/moodledata';

if ($_ENV['PORT'] == '80')
{
    # if using port 80 just add http to url
    $CFG->wwwroot = 'http://' . $_ENV['URL'];
} 
else if ($_ENV['PORT'] == '443') 
{
    # if using ssl then enable sslproxy and 
    # put https on url
    $CFG->sslproxy = true;
    $CFG->wwwroot = 'https://' . $_ENV['URL'];
} 
else
{
    # if using nonstandard port put http and port in url
    # enable reverse proxy as well
    $CFG->wwwroot = 'http://' . $_ENV['URL'] . ":" . $_ENV['PORT'];
}

# redis config
$CFG->session_handler_class = '\core\session\redis';
$CFG->session_redis_host = 'localhost';
$CFG->session_redis_port = 6379;
$CFG->session_redis_database = 0;
$CFG->session_redis_acquire_lock_timeout = 120;
$CFG->session_redis_lock_expire = 7200;
$CFG->session_redis_lock_retry = 100;

# if development
if($_ENV['MODE'] == "development") 
{
    # force debugging
    @error_reporting(E_ALL | E_STRICT);
    @ini_set('display_errors', '1');
    $CFG->debug = (E_ALL | E_STRICT);
    $CFG->debugdisplay = 1;
}

# nginx config
$CFG->xsendfile = 'X-Accel-Redirect';
$CFG->xsendfilealiases = array(
    '/dataroot/' => $CFG->dataroot
);

# setup paths
$CFG->pathtogs = '/usr/bin/ghostscript';
$CFG->pathtophp = '/usr/local/bin/php';
$CFG->pathtodu = '/usr/bin/du';
$CFG->aspellpath = '/usr/bin/aspell';
$CFG->pathtodot = '/usr/bin/dot';
$CFG->pathtopdftoppm = '/usr/bin/pdftoppm';
$CFG->pathtopython = '/usr/bin/python3';
# $CFG->pathtounoconv = ''; # too large

$CFG->cronclionly = false;  
$CFG->cronremotepassword = $_ENV['CRON_PASSWORD'];  

# config for blocks
$CFG->defaultblocks_override = 'uai,navigation,settings';
 
##############################################

require_once(__DIR__ . '/lib/setup.php'); // Do not edit

// There is no php closing tag in this file,
// it is intentional because it prevents trailing whitespace problems!
