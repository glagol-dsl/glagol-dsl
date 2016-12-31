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
import IO;
import ValueIO;

private str COMPILE_LOG = ".glagol_compile_log";

public void compile(loc projectPath, int listenerId) {
	Config config = loadConfig(projectPath);
	
	loc logFile = getCompilePath(config) + COMPILE_LOG;
	
	cleanUpOld(logFile, listenerId);
	
    list[loc] sourceFiles = findAllSourceFiles(projectPath);
    
    list[Declaration] glagolParsed = [ast | fileLoc <- sourceFiles, Declaration ast := parseModule(fileLoc)];
        
    list[loc] compiledFiles = [];
    
    for (l <- glagolParsed, out := toPHPScript(<getFramework(config), getORM(config)>, l.\module, glagolParsed), str outputFile <- out) {
    	compiledFiles += createSourceFile(outputFile, toCode(out[outputFile]), config);
    	respondWith(info("Compiled source file <outputFile>"), listenerId);
    }
    
    map[loc, str] envFiles = generateEnvFiles(config, glagolParsed);
    
    for (f <- envFiles) {
    	writeFile(f, envFiles[f]);
    	compiledFiles += f;
    	respondWith(info("Created env file <f.path>"), listenerId);
    }
    
    createCompileLogFile(logFile, compiledFiles);
	respondWith(info("Compile log put in <logFile.path>"), listenerId);
}

private void cleanUpOld(loc logFile, int listenerId) {
	if (!exists(logFile)) {
		return;
	}
	
	for (loc file <- readBinaryValueFile(#list[loc], logFile)) {
		remove(file);
		respondWith(warning("Removed existing compiled file <file.path>"), listenerId);
	}
}

private loc createCompileLogFile(loc logFile, list[loc] compiledFiles) {
	writeBinaryValueFile(logFile, compiledFiles);
	return logFile;
}

private loc createSourceFile(str outputFile, str code, Config config) {
	loc file = getCompilePath(config) + "src" + outputFile;
	writeFile(file, code);
	
	return file;
}

private list[loc] findAllSourceFiles(loc projectPath) {
    list[loc] sourceFiles = [path | path <- projectPath.ls, !isDirectory(path), path.extension == "g"];

    for (path <- projectPath.ls, isDirectory(path)) {
        sourceFiles += findAllSourceFiles(path);
    }
    
    return sourceFiles;
}
