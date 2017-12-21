module Test::Compiler::Lumen::Bootstrap::App

import Compiler::Lumen::Bootstrap::App;
import Config::Config;

test bool shouldCreateAppFileContents() =
	createAppFile(doctrine(), []) == 
	"\<?php\n" + 
	"require __DIR__ . \"/../vendor/autoload.php\";\n" +
	"$app = new \\Laravel\\Lumen\\Application(realpath(__DIR__ . \"/../\"));\n" +
	"$app-\>\n    singleton(\\Illuminate\\Contracts\\Console\\Kernel::class, \\Laravel\\Lumen\\Console\\Kernel::class);\n" +
	"$app-\>\n    singleton(\\Illuminate\\Contracts\\Debug\\ExceptionHandler::class, \\Glagol\\Bridge\\Lumen\\Exceptions\\Handler::class);\n" +
	"$app-\>\n    register(\\LaravelDoctrine\\ORM\\DoctrineServiceProvider::class);\n" +
	"$app-\>\n    configure(\"database\");\n" + 
	"$app-\>\n    configure(\"doctrine\");\n" + 
	"$app-\>router-\>\n    group([], " +
	"function ($app) {\n" +
	"        require __DIR__ . \"/../routes/api.php\";\n" +
	"    });\n" +
	"return $app;\n";
