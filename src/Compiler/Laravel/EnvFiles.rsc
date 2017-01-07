module Compiler::Laravel::EnvFiles

import Config::Config;
import Config::Reader;
import Compiler::PHP::Compiler;
import Compiler::Laravel::Bootstrap::App;
import Compiler::Laravel::Bootstrap::Autoload;
import Compiler::Laravel::Public::Index;
import Compiler::Laravel::Public::Htaccess;
import Compiler::Laravel::Public::WebConfig;
import Compiler::Laravel::Config::App;
import Compiler::Laravel::Config::Compile;
import Compiler::Laravel::Config::Cache;
import Compiler::Laravel::Config::View;
import Compiler::Laravel::Routes::Api;
import Compiler::Laravel::Routes::Console;
import Compiler::Laravel::Server;
import Compiler::Laravel::Artisan;
import Syntax::Abstract::Glagol;
import Syntax::Abstract::PHP;
import Syntax::Abstract::PHP::Helpers;
import IO;

public map[loc, str] generateFrameworkFiles(laravel(), Config config, list[Declaration] ast) = (
	getCompilePath(config) + "bootstrap/app.php": createAppFile(),
    getCompilePath(config) + "bootstrap/autoload.php": createAutoloadFile(),
    getCompilePath(config) + "bootstrap/cache/.gitignore": "",
	getCompilePath(config) + "public/index.php": createIndexFile(),
	getCompilePath(config) + "public/.htaccess": createHtaccess(),
    getCompilePath(config) + "public/web.config": createWebConfig(),
    getCompilePath(config) + "artisan": createArtisan(),
    getCompilePath(config) + "config/app.php": createAppConfig(),
    getCompilePath(config) + "config/cache.php": createCacheConfig(),
    getCompilePath(config) + "config/compile.php": createCompileConfig(),
    getCompilePath(config) + "config/view.php": createViewConfig(),
    getCompilePath(config) + "routes/api.php": createRoutesApi(ast),
    getCompilePath(config) + "routes/console.php": createRoutesConsole(),
    getCompilePath(config) + "server.php": createServerFile()
);
