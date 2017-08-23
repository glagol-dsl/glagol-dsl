module Compiler::EnvFiles

import Compiler::Composer::ComposerFile;
import Compiler::Lumen::EnvFiles;
import Syntax::Abstract::Glagol;
import Config::Config;
import Config::Reader;

public map[loc, str] generateEnvFiles(Config config, list[Declaration] ast) = 
	(|file:///composer.json|: generateComposerFile(config, ast)) +
	generateFrameworkFiles(getFramework(config), config, ast)
	;
