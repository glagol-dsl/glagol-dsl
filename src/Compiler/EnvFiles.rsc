module Compiler::EnvFiles

import Utils::Glue;
import Syntax::Abstract::Glagol;
import Config::Config;

public map[loc, str] generateEnvFiles(Config config, list[Declaration] ast) = 
	(config.outPath + "composer.json": generateComposerFile(config, ast));

private set[str] namespaces(list[Declaration] ast) = 
	{f.\module.namespace.name | f <- ast};

private str getFrameworkDependencies(laravel()) = 
	"\"laravel/framework\": \"5.3.*\"";
	
private str getORMDependencies(doctrine()) = 
	"\"doctrine/orm\": \"~2.5\"";

private str generateComposerFile(Config config, list[Declaration] ast) =
	"{
	'  \"name\": \"<config.name>\",
	'  \"description\": \"<config.description>\",
	'  \"minimum-stability\": \"dev\",
	'  \"license\": \"gnu-gpl3\",
	'  \"authors\": [
	'    {
	'      \"name\": \"John Doe\",
	'      \"email\": \"joan.grigorov@gmail.com\"
	'    }
	'  ],
	'  \"autoload\": {
	'    \"psr-4\": {
	'		<glue(["\"<n>\\\\\": \"<config.srcPath.file>/\"" | n <- namespaces(ast)], ", ")>
	'	 }
	'  },
	'  \"require\": {
	'	 <getFrameworkDependencies(config.framework)>,
	'	 <getORMDependencies(config.orm)>,
	'    \"php\": \"^7.0\",
	'	 \"bulgaria-php/glagol-php-overriding\": \"dev-master\",
	'	 \"bulgaria-php/glagol-php-ds\": \"dev-master\"
	'  }
	'}";
