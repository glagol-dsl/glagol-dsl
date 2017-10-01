module Test::Compiler::Lumen::Config::Database

import Compiler::Lumen::Config::Database;
import Syntax::Abstract::PHP;
import Compiler::Lumen::Config::Abstract;
import Compiler::PHP::Compiler;

test bool shouldCreateLumenDatabaseConfig() =
    createDatabaseConfig() == 
    "\<?php\n" + 
	"return [\"connections\" =\> [\"mysql\" =\> [\"port\" =\> env(\"DB_PORT\", \"3306\"), \"engine\" =\> null, \"charset\" =\> \"utf8\", \"prefix\" =\> \"\"," + 
	" \"username\" =\> env(\"DB_USERNAME\", \"root\"), \"driver\" =\> \"mysql\", \"host\" =\> env(\"DB_HOST\", \"127.0.0.1\"), \"strict\" =\> true, " + 
	"\"collation\" =\> \"utf8_unicode_ci\", \"database\" =\> env(\"DB_DATABASE\", \"glagol\"), \"password\" =\> env(\"DB_PASSWORD\", \"\")]]];\n";
