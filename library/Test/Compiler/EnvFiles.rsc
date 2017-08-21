module Test::Compiler::EnvFiles

import Compiler::EnvFiles;
import Syntax::Abstract::Glagol;
import lang::json::ast::JSON;
import Config::Config;
import Config::Reader;
import Map;

test bool shouldGenerateEnvFilesForLaravelAndDoctrine() = 
    domain(generateEnvFiles(newConfig(), [])) ==
    {
      |file:///config/app.php|,
      |file:///config/doctrine.php|,
      |file:///bootstrap/cache/.gitignore|,
      |file:///bootstrap/app.php|,
      |file:///server.php|,
      |file:///config/database.php|,
      |file:///public/.htaccess|,
      |file:///artisan|,
      |file:///routes/console.php|,
      |file:///routes/api.php|,
      |file:///public/index.php|,
      |file:///composer.json|
    };
    
test bool shouldGenerateEnvFilesForLaravelAndDoctrineAndHavingARepository() = 
    domain(generateEnvFiles(newConfig(), [
        file(|file:///|, \module(namespace("Test"), [
            \import("User", namespace("Test"), "User")
        ], repository("User", []))),
        file(|file:///|, \module(namespace("Test"), [], entity("User", [])))
    ])) ==
    {
      |file:///config/app.php|,
      |file:///config/doctrine.php|,
      |file:///bootstrap/cache/.gitignore|,
      |file:///bootstrap/app.php|,
      |file:///server.php|,
      |file:///config/database.php|,
      |file:///public/.htaccess|,
      |file:///artisan|,
      |file:///routes/console.php|,
      |file:///routes/api.php|,
      |file:///public/index.php|,
      |file:///composer.json|,
      |file:///app/Provider/UserRepositoryProvider.php|
    };
