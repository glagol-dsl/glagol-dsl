module Compiler::EnvFiles

import Compiler::Composer::ComposerFile;
import Compiler::Laravel::EnvFiles;
import Syntax::Abstract::Glagol;
import Config::Config;
import Config::Reader;

public map[loc, str] generateEnvFiles(Config config, list[Declaration] ast) = 
	(getCompilePath(config) + COMPOSER_FILE: generateComposerFile(config, ast)) +
	generateFrameworkFiles(getFramework(config), config, ast)
	;
