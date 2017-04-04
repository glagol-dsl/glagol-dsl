module Test::Compiler::Laravel::Bootstrap::Autoload

import Compiler::Laravel::Bootstrap::Autoload;

test bool shouldCreateLaravelAppFileContents() =
	createAutoloadFile() == 
	"\<?php\n" + 
	"define(\"LARAVEL_START\", microtime(true));\n" + 
	"require __DIR__ . \"/../vendor/autoload.php\";\n" + 
	"$compiledPath = __DIR__ . \"/cache/compiled.php\";\n" + 
	"if (file_exists($compiledPath)) {\n" + 
	"    require $compiledPath;\n" + 
	"}\n";
