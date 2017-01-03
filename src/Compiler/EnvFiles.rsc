module Compiler::EnvFiles

import Compiler::Composer::ComposerFile;
import Syntax::Abstract::Glagol;
import Config::Config;
import Config::Reader;

public map[loc, str] generateEnvFiles(Config config, list[Declaration] ast) = 
	(getCompilePath(config) + COMPOSER_FILE: generateComposerFile(config, ast));
