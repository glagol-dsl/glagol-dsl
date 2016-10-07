module Config::Reader

import lang::yaml::Model;
import IO;
import String;

data Framework
    = zend()
    | symfony()
    | laravel()
    ;

data ORM
    = doctrine()
    ;

alias Config = tuple[Framework framework, ORM orm];

public Config loadGlagolConfig(loc projectPath) = loadGlagolConfig(readFile(projectPath + ".glagol"));
public Config loadGlagolConfig(str configSource) = parseRawYaml(loadYAML(configSource));

private Config parseRawYaml(mapping(vals)) = <findFramework(vals), findOrm(vals)>;

private Framework findFramework(map[Node, Node] vals) = convertFramework(toSimpleMap(vals)["framework"]);
private ORM findOrm(map[Node, Node] vals) = convertORM(toSimpleMap(vals)["orm"]);

private Framework convertFramework("zend") = zend();
private Framework convertFramework("symfony") = symfony();
private Framework convertFramework("laravel") = laravel();

private ORM convertORM("doctrine") = doctrine();

private map[str, str] toSimpleMap(map[Node, Node] nodes) = ("<s.\value>" : "<nodes[s].\value>" | s <- nodes);
