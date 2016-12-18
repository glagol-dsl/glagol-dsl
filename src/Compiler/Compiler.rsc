module Compiler::Compiler

import Config::Reader;
import Daemon::TcpServer;
import Compiler::Vendors;
import Syntax::Abstract::Glagol;
import Parser::ParseAST;
import IO;

public void compile(loc projectPath) {
    Config config = loadGlagolConfig(projectPath);
    list[loc] sourceFiles = findAllSourceFiles(projectPath);
    
    map[loc, str] compiled
        = (c.outputFile : c.code | fileLoc <- sourceFiles, Declaration ast := parseModule(fileLoc), c := compileUnit(config, ast));
        
    for (l <- compiled) {
        println(l);
        println(compiled[l]);
    }
}

private list[loc] findAllSourceFiles(loc projectPath) {
    list[loc] sourceFiles = [path | path <- projectPath.ls, !isDirectory(path), path.extension == "g"];

    for (path <- projectPath.ls, isDirectory(path)) {
        sourceFiles += findAllSourceFiles(path);
    }
    
    return sourceFiles;
}
