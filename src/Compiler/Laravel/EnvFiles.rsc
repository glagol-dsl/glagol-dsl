module Compiler::Laravel::EnvFiles

import Config::Config;
import Config::Reader;
import Compiler::PHP::Compiler;
import Syntax::Abstract::PHP;
import Syntax::Abstract::PHP::Helpers;
import IO;

private str loadPreset(str preset) = readFile(|cwd:///../static/laravel/| + "<preset>");

public map[loc, str] generateFrameworkFiles(laravel(), Config config) = (
	getCompilePath(config) + "bootstrap/app.php": loadPreset("bootstrap/app.php"),
	getCompilePath(config) + "bootstrap/autoload.php": loadPreset("bootstrap/autoload.php"),
	getCompilePath(config) + "public/index.php": loadPreset("public/index.php"),
	getCompilePath(config) + "public/.htaccess": loadPreset("public/.htaccess"),
	getCompilePath(config) + "public/web.config": loadPreset("public/web.config"),
	getCompilePath(config) + "app/Exceptions/Handler.php": loadPreset("app/Exceptions/Handler.php"),
	getCompilePath(config) + "app/Http/Kernel.php": loadPreset("app/Http/Kernel.php"),
	getCompilePath(config) + "app/Console/Kernel.php": loadPreset("app/Console/Kernel.php"),
	getCompilePath(config) + "app/Http/Controllers/Controller.php": loadPreset("app/Http/Controllers/Controller.php"),
	getCompilePath(config) + "app/Providers/RouteServiceProvider.php": loadPreset("app/Providers/RouteServiceProvider.php")
);
