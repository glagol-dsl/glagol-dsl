module Test::Compiler::Lumen::Bootstrap::App

import Compiler::Lumen::Bootstrap::App;

test bool shouldCreateAppFileContents() =
	createAppFile() == 
	"\<?php\n" + 
	"require __DIR__ . \"/../vendor/autoload.php\";\n" +
	"$app = new \\Laravel\\Lumen\\Application(realpath(__DIR__ . \"/../\"));\n" +
	"$app-\>singleton(\\Illuminate\\Contracts\\Console\\Kernel::class, \\Laravel\\Lumen\\Console\\Kernel::class);\n" +
	"$app-\>singleton(\\Illuminate\\Contracts\\Debug\\ExceptionHandler::class, \\Laravel\\Lumen\\Exceptions\\Handler::class);\n" +
	"$app-\>configure(\"app\");\n" + 
	"$app-\>configure(\"database\");\n" + 
	"$app-\>configure(\"doctrine\");\n" + 
	"$app-\>group([\n    \n], " +
	"function ($app) {\n" +
	"    require __DIR__ . \"/../routes/api.php\";\n" +
	"});\n" +
	"return $app;\n";
