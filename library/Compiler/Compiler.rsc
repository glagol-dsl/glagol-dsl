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

public void compile(loc projectPath, int listenerId) {
	Config config = loadConfig(projectPath);
	
    list[Declaration] ast = parseMultiple(
        findAllSourceFiles(getSourcesPath(config)) + findAllSourceFiles(getVendorPath(config))
    );
    
    TypeEnv typeEnv = checkAST(config, ast);
    
    if (hasErrors(typeEnv)) {
    	for (<_, str msg> <- getErrors(typeEnv)) {
    		respondWith(error(msg), listenerId);
    	}
    	
    	for (str id <- typeEnv.definitions) {
    		respondWith(info("<id>: <typeEnv.definitions[id]>"), listenerId);
    	}
    	return;
    }
    
	cleanUpOld(config, listenerId);
    
    list[loc] compiledFiles = [];
    
    for (l <- ast, out := toPHPScript(<getFramework(config), getORM(config)>, l.\module, ast), str outputFile <- out) {
    	compiledFiles += createSourceFile(outputFile, toCode(out[outputFile]), config);
    	respondWith(info("Compiled source file <outputFile>"), listenerId);
    }
    
    map[loc, str] envFiles = generateEnvFiles(config, ast);
    
    for (f <- envFiles) {
    	writeFile(f, envFiles[f]);
    	compiledFiles += f;
    	respondWith(info("Created source file <f.path>"), listenerId);
    }
    
    createCompileLogFile(config, compiledFiles, listenerId);
}

private void cleanUpOld(Config config, int listenerId) {

	loc logFile = getCompilePath(config) + COMPILE_LOG;

	if (!exists(logFile)) {
		return;
	}
	
	for (loc file <- readBinaryValueFile(#list[loc], logFile), exists(file)) {
		remove(file);
		respondWith(warning("Removed existing compiled file <file.path>"), listenerId);
	}
}

private loc createCompileLogFile(Config config, list[loc] compiledFiles, int listenerId) {
	loc logFile = getCompilePath(config) + COMPILE_LOG;
	writeBinaryValueFile(logFile, compiledFiles);
	respondWith(info("Compile log put in <logFile.path>"), listenerId);
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
