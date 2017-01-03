<?php
define('LARAVEL_START', microtime(true));

require __DIR__.'/../vendor/autoload.php';

$compiledPath = __DIR__.'/cache/compiled.php';

if (file_exists($compiledPath)) {
    require $compiledPath;
}
