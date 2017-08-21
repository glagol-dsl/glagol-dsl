module Test::Compiler::Laravel::Public::Index

import Compiler::Laravel::Public::Index;

test bool testCreateIndexFile() = 
	createIndexFile() == 
	"\<?php\n" + 
	"$app = require_once __DIR__ . \"/../bootstrap/app.php\";\n" + 
	"$app-\>run();\n";
