module Compiler::Compiler

import Daemon::Response;
import Syntax::Abstract::Glagol;
import Syntax::Abstract::PHP;
import Parser::ParseAST;
import Config::Config;
import Config::Reader;
import Compiler::PHP::Compiler;
import Compiler::EnvFiles;
import Transform::Glagol2PHP::Namespaces;
import Typechecker::CheckFile;
import Typechecker::Env;
import IO;
import ValueIO;

private str COMPILE_LOG = ".glagol_compile_log";

public void compile(loc projectPath, list[loc] sources, int listenerId) {
	Config config = loadConfig(projectPath);
	
    list[Declaration] ast = parseMultiple(sources);
    
    TypeEnv typeEnv = checkAST(config, ast);
    
    if (hasErrors(typeEnv)) {
		respondWith(error("Cannot compile, errors found:"), listenerId);
    	for (<loc src, str msg> <- getErrors(typeEnv)) {
    		respondWith(text("[<relative(src, config)><line(src)>] <msg>"), listenerId);
    	}
    	return;
    }
    
    respondWith(clean(getCompilePath(config) + COMPILE_LOG), listenerId);
    
    list[loc] compiledFiles = [];
    
    for (l <- ast, out := toPHPScript(<getFramework(config), getORM(config)>, l.\module, ast), str outputFile <- out) {
    	compiledFiles += createSourceFile(outputFile, toCode(out[outputFile]), config, listenerId);
    }
    
    map[loc, str] envFiles = generateEnvFiles(config, ast);
    
    for (f <- envFiles) {
    	respondWith(writeRemoteFile(f, envFiles[f]), listenerId);
    	compiledFiles += f;
    }
    
    createCompileLogFile(config, compiledFiles, listenerId);
}

private str line(loc src) = ":<src.begin.line>" when src.begin? && src.begin.line?;
private str line(loc src) = "";

private loc createCompileLogFile(Config config, list[loc] compiledFiles, int listenerId) {
	loc logFile = getCompilePath(config) + COMPILE_LOG;
	respondWith(writeRemoteLogFile(logFile, compiledFiles), listenerId);
	return logFile;
}

private loc createSourceFile(str outputFile, str code, Config config, int listenerId) {
	loc file = getCompilePath(config) + "src" + outputFile;
	respondWith(writeRemoteFile(file, code), listenerId);
	
	return file;
}

private list[loc] findAllSourceFiles(loc projectPath) {
    list[loc] sourceFiles = [path | path <- projectPath.ls, !isDirectory(path), path.extension == "g"];

    for (path <- projectPath.ls, isDirectory(path)) {
        sourceFiles += findAllSourceFiles(path);
    }
    
    return sourceFiles;
}
