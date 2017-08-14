module Test::Compiler::EnvFiles

import Compiler::EnvFiles;
import Syntax::Abstract::Glagol;
import lang::json::ast::JSON;
import Config::Config;
import Map;

test bool shouldGenerateEnvFilesForLaravelAndDoctrine() = 
    domain(generateEnvFiles(<object(("glagol": object(("framework": string("laravel"), "orm": string("doctrine"))))), |temp:///|>, [])) ==
    {
      |temp:///out/config/app.php|,
      |temp:///out/bootstrap/autoload.php|,
      |temp:///out/config/doctrine.php|,
      |temp:///out/public/web.config|,
      |temp:///out/bootstrap/cache/.gitignore|,
      |temp:///out/bootstrap/app.php|,
      |temp:///out/server.php|,
      |temp:///out/config/compile.php|,
      |temp:///out/config/database.php|,
      |temp:///out/public/.htaccess|,
      |temp:///out/artisan|,
      |temp:///out/routes/console.php|,
      |temp:///out/config/view.php|,
      |temp:///out/routes/api.php|,
      |temp:///out/.env|,
      |temp:///out/config/cache.php|,
      |temp:///out/public/index.php|,
      |temp:///out/composer.json|
    };
    
test bool shouldGenerateEnvFilesForLaravelAndDoctrineAndHavingARepository() = 
    domain(generateEnvFiles(<object(("glagol": object(("framework": string("laravel"), "orm": string("doctrine"))))), |temp:///|>, [
        file(|temp:///|, \module(namespace("Test"), [
            \import("User", namespace("Test"), "User")
        ], repository("User", []))),
        file(|temp:///|, \module(namespace("Test"), [], entity("User", [])))
    ])) ==
    {
      |temp:///out/config/app.php|,
      |temp:///out/bootstrap/autoload.php|,
      |temp:///out/config/doctrine.php|,
      |temp:///out/public/web.config|,
      |temp:///out/bootstrap/cache/.gitignore|,
      |temp:///out/bootstrap/app.php|,
      |temp:///out/server.php|,
      |temp:///out/config/compile.php|,
      |temp:///out/config/database.php|,
      |temp:///out/public/.htaccess|,
      |temp:///out/artisan|,
      |temp:///out/routes/console.php|,
      |temp:///out/config/view.php|,
      |temp:///out/routes/api.php|,
      |temp:///out/.env|,
      |temp:///out/config/cache.php|,
      |temp:///out/public/index.php|,
      |temp:///out/composer.json|,
      |temp:///out/app/Provider/UserRepositoryProvider.php|
    };
