module Test::Compiler::Laravel::Public::Index

import Compiler::Laravel::Public::Index;

test bool testCreateIndexFile() = 
	createIndexFile() == 
	"\<?php\n" + 
	"require __DIR__ . \"/../bootstrap/autoload.php\";\n" + 
	"$app = require_once __DIR__ . \"/../bootstrap/app.php\";\n" + 
	"$kernel = $app-\>make(Illuminate\\Contracts\\Http\\Kernel::class);\n" + 
	"$response = $kernel-\>handle($request = Illuminate\\Http\\Request::capture());\n" + 
	"$response-\>send();\n" + 
	"$kernel-\>terminate($request, $response);\n";
