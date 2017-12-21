module Test::Compiler::Lumen::Public::Index

import Compiler::Lumen::Public::Index;

test bool testCreateIndexFile() = 
	createIndexFile() == 
	"\<?php\n" + 
	"$app = require_once __DIR__ . \"/../bootstrap/app.php\";\n" + 
	"$app-\>\n    run();\n";
