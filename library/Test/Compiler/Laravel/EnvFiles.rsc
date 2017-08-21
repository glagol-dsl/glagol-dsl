module Test::Compiler::Laravel::EnvFiles

import Compiler::Laravel::EnvFiles;
import Syntax::Abstract::Glagol;
import Config::Config;
import Config::Reader;
import lang::json::ast::JSON;
import Map;

test bool shouldGenerateLaravelFrameworkEnvFiles() =
    domain(generateFrameworkFiles(laravel(), newConfig(), [])) == {
      |file:///config/app.php|,
      |file:///bootstrap/autoload.php|,
      |file:///config/doctrine.php|,
      |file:///public/web.config|,
      |file:///bootstrap/cache/.gitignore|,
      |file:///bootstrap/app.php|,
      |file:///server.php|,
      |file:///config/compile.php|,
      |file:///config/database.php|,
      |file:///public/index.php|,
      |file:///public/.htaccess|,
      |file:///artisan|,
      |file:///routes/console.php|,
      |file:///config/view.php|,
      |file:///routes/api.php|,
      |file:///config/cache.php|
    };
    
test bool shouldGenerateLaravelFrameworkEnvFilesWithRepositoryProviders() =
    domain(generateFrameworkFiles(laravel(), newConfig(), [
        file(|temp:///|, \module(namespace("Test"), [
            \import("User", namespace("Test"), "User")
        ], repository("User", [])))
    ])) == {
      |file:///config/app.php|,
      |file:///bootstrap/autoload.php|,
      |file:///config/doctrine.php|,
      |file:///public/web.config|,
      |file:///bootstrap/cache/.gitignore|,
      |file:///bootstrap/app.php|,
      |file:///server.php|,
      |file:///config/compile.php|,
      |file:///config/database.php|,
      |file:///public/index.php|,
      |file:///public/.htaccess|,
      |file:///artisan|,
      |file:///routes/console.php|,
      |file:///config/view.php|,
      |file:///routes/api.php|,
      |file:///config/cache.php|,
      |file:///app/Provider/UserRepositoryProvider.php|
    };
