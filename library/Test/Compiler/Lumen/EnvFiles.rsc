module Test::Compiler::Lumen::EnvFiles

import Compiler::Lumen::EnvFiles;
import Syntax::Abstract::Glagol;
import Config::Config;
import Config::Reader;
import lang::json::ast::JSON;
import Map;

test bool shouldGenerateLumenFrameworkEnvFiles() =
    domain(generateFrameworkFiles(lumen(), newConfig(), [])) == {
      |file:///config/app.php|,
      |file:///config/doctrine.php|,
      |file:///bootstrap/cache/.gitignore|,
      |file:///bootstrap/app.php|,
      |file:///server.php|,
      |file:///config/database.php|,
      |file:///public/index.php|,
      |file:///public/.htaccess|,
      |file:///artisan|,
      |file:///routes/console.php|,
      |file:///routes/api.php|
    };
    
test bool shouldGenerateLumenFrameworkEnvFilesWithRepositoryProviders() =
    domain(generateFrameworkFiles(lumen(), newConfig(), [
        file(|temp:///|, \module(namespace("Test"), [
            \import("User", namespace("Test"), "User")
        ], repository("User", [])))
    ])) == {
      |file:///config/app.php|,
      |file:///config/doctrine.php|,
      |file:///bootstrap/cache/.gitignore|,
      |file:///bootstrap/app.php|,
      |file:///server.php|,
      |file:///config/database.php|,
      |file:///public/index.php|,
      |file:///public/.htaccess|,
      |file:///artisan|,
      |file:///routes/console.php|,
      |file:///routes/api.php|,
      |file:///app/Provider/UserRepositoryProvider.php|
    };
