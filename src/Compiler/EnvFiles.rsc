module Compiler::EnvFiles

import Utils::Glue;
import Syntax::Abstract::Glagol;
import Config::Config;
import Config::Reader;
import lang::json::IO;
import lang::json::ast::JSON;
import Map;

public map[loc, str] generateEnvFiles(Config config, list[Declaration] ast) = 
	(getCompilePath(config) + COMPOSER_FILE: generateComposerFile(config, ast));

private set[str] namespaces(list[Declaration] ast) = 
	{f.\module.namespace.name | f <- ast};
	
private str generateComposerFile(Config config, list[Declaration] ast) = 
    toJSON(removeGlagolProps(setAutoloading(setDependencies(config.composer), config, ast)));

private JSON removeGlagolProps(object(map[str, JSON] properties)) = object(delete(properties, "glagol"));

private JSON setDependencies(object(map[str, JSON] properties)) = object(merge(properties, (
    "require": object((
        "laravel/framework": string("^5.3"),
        "doctrine/orm": string("~2.5"),
        "php": string("^7.0"),
        "bulgaria-php/glagol-php-overriding": string("dev-master"),
        "bulgaria-php/glagol-php-ds": string("dev-master")
    ))
)));

private JSON setAutoloading(object(map[str, JSON] properties), Config config, list[Declaration] ast) = object(merge(properties, (
    "autoload": object((
        "psr-4": object((
            "<n>\\": string("<getSourcesPath(config).file>/") |  n <- namespaces(ast)
        ))
    ))
)));

private map[&K, &T] merge(map[&K, &T] a, map[&K, &T] b) {
    for (k <- b) {
        if (a[k]? && object(_) := a[k]) {
            a[k] = object(merge(a[k].properties, b[k].properties));
        } else {
            a[k] = b[k];
        }
    }
    
    return a;
}
