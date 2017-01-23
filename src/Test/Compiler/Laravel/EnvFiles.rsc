module Test::Compiler::Laravel::EnvFiles

import Compiler::Laravel::EnvFiles;
import Syntax::Abstract::Glagol;
import Config::Config;
import lang::json::ast::JSON;
import Map;

test bool shouldGenerateLaravelFrameworkEnvFiles() =
    domain(generateFrameworkFiles(laravel(), <object(("glagol":object(("orm":string("doctrine"))))), |temp:///|>, [])) == {
      |temp:///out/config/app.php|,
      |temp:///out/bootstrap/autoload.php|,
      |temp:///out/config/doctrine.php|,
      |temp:///out/public/web.config|,
      |temp:///out/bootstrap/cache/.gitignore|,
      |temp:///out/bootstrap/app.php|,
      |temp:///out/server.php|,
      |temp:///out/config/compile.php|,
      |temp:///out/config/database.php|,
      |temp:///out/public/index.php|,
      |temp:///out/public/.htaccess|,
      |temp:///out/artisan|,
      |temp:///out/routes/console.php|,
      |temp:///out/config/view.php|,
      |temp:///out/routes/api.php|,
      |temp:///out/.env|,
      |temp:///out/config/cache.php|
    };
    
test bool shouldGenerateLaravelFrameworkEnvFilesWithRepositoryProviders() =
    domain(generateFrameworkFiles(laravel(), <object(("glagol":object(("orm":string("doctrine"))))), |temp:///|>, [
        file(|temp:///|, \module(namespace("Test"), [
            \import("User", namespace("Test"), "User")
        ], repository("User", [])))
    ])) == {
      |temp:///out/config/app.php|,
      |temp:///out/bootstrap/autoload.php|,
      |temp:///out/config/doctrine.php|,
      |temp:///out/public/web.config|,
      |temp:///out/bootstrap/cache/.gitignore|,
      |temp:///out/bootstrap/app.php|,
      |temp:///out/server.php|,
      |temp:///out/config/compile.php|,
      |temp:///out/config/database.php|,
      |temp:///out/public/index.php|,
      |temp:///out/public/.htaccess|,
      |temp:///out/artisan|,
      |temp:///out/routes/console.php|,
      |temp:///out/config/view.php|,
      |temp:///out/routes/api.php|,
      |temp:///out/.env|,
      |temp:///out/config/cache.php|,
      |temp:///out/app/Provider/UserRepositoryProvider.php|
    };