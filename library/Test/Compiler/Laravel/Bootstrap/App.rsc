module Test::Compiler::Laravel::Bootstrap::App

import Compiler::Laravel::Bootstrap::App;

test bool shouldCreateAppFileContents() =
	createAppFile() == 
	"\<?php\n" + 
	"$app = new Illuminate\\Foundation\\Application(realpath(__DIR__ . \"/../\"));\n" + 
	"$app-\>singleton(Illuminate\\Contracts\\Http\\Kernel::class, Glagol\\Bridge\\Laravel\\Http\\Kernel::class);\n" + 
	"$app-\>singleton(Illuminate\\Contracts\\Console\\Kernel::class, Glagol\\Bridge\\Laravel\\Console\\Kernel::class);\n" + 
	"$app-\>singleton(Illuminate\\Contracts\\Debug\\ExceptionHandler::class, Glagol\\Bridge\\Laravel\\Exceptions\\Handler::class);\n" + 
	"return $app;\n";
