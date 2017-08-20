module Config::Reader

import Config::Config;
import Exceptions::ConfigExceptions;
import lang::json::IO;
import lang::json::ast::JSON;
import List;
import String;
import IO;

public str COMPOSER_FILE = "composer.json";

alias Config = tuple[
	JSON composer,
	loc projectPath
];

public Config loadConfig(loc projectPath) {

	loc configPath = projectPath + COMPOSER_FILE;

	if (!exists(configPath)) {
		return loadConfig(false, projectPath);
	}

	return loadConfig(readFile(configPath), projectPath);
}

public Config loadConfig(false, loc projectPath) = <object(()), projectPath>;
public Config loadConfig(str configSource, loc projectPath) = <fromJSON(#JSON, configSource), projectPath>;
public Config loadConfig(str configSource) = <fromJSON(#JSON, configSource), |tmp:///|>;

public map[str, str] getConfig(loc file) = 
    exists(file) ? flatToMap(fromJSON(#JSON, readFile(file))) : ();

private map[str, str] flatToMap(object(map[str, JSON] properties)) =
    (p: toFlatVal(properties[p]) | p <- properties);

private str toFlatVal(string(a)) = "<a>";
private str toFlatVal(number(a)) = "<a>";
private str toFlatVal(boolean(a)) = "<a>";
private default str toFlatVal(_) = "";

public Framework getFramework(Config config) = getFramework(config.composer);
public Framework getFramework(JSON composer) = convertFramework(getProperty(composer, null(), "glagol", "framework"));

public ORM getORM(Config config) = getORM(config.composer);
public ORM getORM(JSON composer) = convertORM(getProperty(composer, null(), "glagol", "orm"));

public str relative(loc src, Config config) = replaceFirst(src.path, config.projectPath.path, "");

public loc getCompilePath(Config config) = config.projectPath + getProperty(config.composer, string("out"), "glagol", "paths", "out").s;
public loc getSourcesPath(Config config) = config.projectPath + getProperty(config.composer, string("src"), "glagol", "paths", "src").s;
public loc getVendorPath(Config config) = config.projectPath + getProperty(config.composer, string("vendor"), "config", "vendor-dir").s;
public loc getConfigPath(Config config) = config.projectPath + getProperty(config.composer, string("config"), "glagol", "paths", "config").s;

public bool hasProperty(object(map[str, JSON] properties), str key...) = properties[key[0]]? && hasProperty(properties[key[0]], headTail(key)[1]) when size(key) > 1;
public bool hasProperty(object(map[str, JSON] properties), str key...) = properties[key[0]]? when size(key) == 1;

public JSON getProperty(object(map[str, JSON] properties), JSON \default, str key...) = getProperty(properties[key[0]], \default, headTail(key)[1]) when size(key) > 1 && properties[key[0]]?;
public JSON getProperty(object(map[str, JSON] properties), JSON \default, str key...) = \default when size(key) > 1 && !properties[key[0]]?;
public JSON getProperty(object(map[str, JSON] properties), JSON \default, str key...) = \default when size(key) == 1 && !properties[key[0]]?;
public JSON getProperty(object(map[str, JSON] properties), JSON \default, str key...) = properties[key[0]] when size(key) == 1 && properties[key[0]]?;

private Framework convertFramework(string("laravel")) = laravel();

@doc="Default framework is laravel"
private Framework convertFramework(null()) = laravel();

private Framework convertFramework(string(str framework)) {
    throw InvalidFramework("Invalid framework \"<framework>\"");
}

private ORM convertORM(string("doctrine")) = doctrine();
@doc="Default ORM is doctrine"
private ORM convertORM(null()) = doctrine();
private ORM convertORM(string(str invalid)) {
    throw InvalidORM("Invalid ORM \"<invalid>\"");
}
