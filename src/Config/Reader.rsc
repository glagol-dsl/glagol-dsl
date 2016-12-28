module Config::Reader

import Config::Config;
import Exceptions::ConfigExceptions;
import lang::json::IO;
import lang::json::ast::JSON;
import List;
import IO;

private str COMPOSER_FILE = "composer.json";

alias Config = tuple[
	JSON composer,
	loc projectPath
];

public Config loadConfig(loc projectPath) = loadConfig(readFile(projectPath + COMPOSER_FILE), projectPath);
public Config loadConfig(str configSource, loc projectPath) = <fromJSON(#JSON, configSource), projectPath>;
public Config loadConfig(str configSource) = <fromJSON(#JSON, configSource), |tmp:///|>;

public Framework getFramework(JSON composer) = convertFramework(getProperty(composer, null(), "glagol", "framework"));
public ORM getORM(JSON composer) = convertORM(getProperty(composer, null(), "glagol", "orm"));

public bool hasProperty(object(map[str, JSON] properties), str key...) = properties[key[0]]? && hasProperty(properties[key[0]], headTail(key)[1]) when size(key) > 1;
public bool hasProperty(object(map[str, JSON] properties), str key...) = properties[key[0]]? when size(key) == 1;

public JSON getProperty(object(map[str, JSON] properties), JSON \default, str key...) = getProperty(properties[key[0]], \default, headTail(key)[1]) when size(key) > 1 && properties[key[0]]?;
public JSON getProperty(object(map[str, JSON] properties), JSON \default, str key...) = \default when size(key) > 1 && !properties[key[0]]?;
public JSON getProperty(object(map[str, JSON] properties), JSON \default, str key...) = \default when size(key) == 1 && !properties[key[0]]?;
public JSON getProperty(object(map[str, JSON] properties), JSON \default, str key...) = properties[key[0]] when size(key) == 1 && properties[key[0]]?;

private Framework convertFramework(string("laravel")) = laravel();

private Framework convertFramework(null()) {
    throw InvalidFramework("Framework not specified");
}

private Framework convertFramework(string(str framework)) {
    throw InvalidFramework("Invalid framework \"<framework>\"");
}

private ORM convertORM(string("doctrine")) = doctrine();
private ORM convertORM(null()) {
    throw InvalidORM("ORM not specified");
}
private ORM convertORM(string(str invalid)) {
    throw InvalidORM("Invalid ORM \"<invalid>\"");
}
