module Config::Reader

import Exceptions::ConfigExceptions;
import lang::yaml::Model;
import IO;
import String;

data Framework
    = zend()
    | anyFramework()
    | laravel()
// TODO    | symfony()
    ;

data ORM
    = doctrine()
    | anyORM()
// TODO    | eloquent()
    ;

alias Config = tuple[
	str name,
	str description,
	Framework framework, 
	ORM orm, 
	loc projectPath, 
	loc srcPath, 
	loc outPath
];

public Config loadGlagolConfig(loc projectPath) = loadGlagolConfig(readFile(projectPath + ".glagol"), projectPath);
public Config loadGlagolConfig(str configSource, loc projectPath) = parseRawYaml(loadYAML(configSource), projectPath);
public Config loadGlagolConfig(str configSource) = parseRawYaml(loadYAML(configSource), |tmp:///|);

private Config parseRawYaml(mapping(vals), loc projectPath) = <
		findName(vals), 
	    findDesc(vals), 
	    findFramework(vals), 
	    findOrm(vals), 
	    projectPath, 
	    findSrc(vals, projectPath), 
	    findOutPath(vals, projectPath)
    >;

private str findName(map[Node, Node] vals) = toSimpleMap(vals)["name"];
private str findDesc(map[Node, Node] vals) = toSimpleMap(vals)["description"];
private Framework findFramework(map[Node, Node] vals) = convertFramework(toSimpleMap(vals)["framework"]);

private ORM findOrm(map[Node, Node] vals) = convertORM(toSimpleMap(vals)["orm"]);

private loc findSrc(map[Node, Node] vals, loc projectPath) {
    map[str, str] configMap = toSimpleMap(vals);
    return (configMap["src_dir"]?) ? projectPath + configMap["src_dir"] : projectPath + "src";
}

private loc findOutPath(map[Node, Node] vals, loc projectPath) {
    map[str, str] configMap = toSimpleMap(vals);
    return (configMap["out_dir"]?) ? projectPath + configMap["out_dir"] : projectPath + "out";
}

private Framework convertFramework("zend") = zend();
private Framework convertFramework("laravel") = laravel();
// TODO private Framework convertFramework("symfony") = symfony();

private Framework convertFramework(str invalid) {
    throw InvalidFramework("Invalid framework \"<invalid>\"");
}

private ORM convertORM("doctrine") = doctrine();
// TODO private ORM convertORM("eloquent") = eloquent();

private ORM convertORM(str invalid) {
    throw InvalidORM("Invalid ORM \"<invalid>\"");
}

private map[str, str] toSimpleMap(map[Node, Node] nodes) = ("<s.\value>" : "<nodes[s].\value>" | s <- nodes);
