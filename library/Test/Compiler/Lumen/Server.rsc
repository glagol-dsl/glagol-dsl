module Test::Compiler::Lumen::Server

import Compiler::Lumen::Server;
import Compiler::PHP::Compiler;
import Syntax::Abstract::PHP;
import Syntax::Abstract::PHP::Helpers;

test bool shouldCreateLumenServerFile() =
    createServerFile() ==  
    "\<?php\n" + 
    "$uri = urldecode(parse_url($_SERVER[\"REQUEST_URI\"], PHP_URL_PATH));\n" + 
    "if ($uri !== \"/\" and file_exists(__DIR__ . \"/public\" . $uri)) {\n" + 
    "}\n" + 
    "require_once __DIR__ . \"/public/index.php\";\n";
