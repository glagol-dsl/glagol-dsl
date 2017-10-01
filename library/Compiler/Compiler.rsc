module Compiler::Compiler

import Daemon::Response;
import Syntax::Abstract::Glagol;
import Syntax::Abstract::PHP;
import Parser::ParseAST;
import Config::Config;
import Config::Reader;
import Compiler::PHP::Compiler;
import Compiler::EnvFiles;
import Compiler::PHP::Code;
import Transform::Glagol2PHP::Namespaces;
import Transform::Env;
import Typechecker::CheckFile;
import Typechecker::Env;
import IO;
import ValueIO;

public void compile(map[loc, str] sources, int listenerId) {
	Config config = newConfig();
	
    list[Declaration] ast = parseMultiple(sources);
    
    TypeEnv typeEnv = checkAST(config, ast);
	
    if (hasErrors(typeEnv)) {
		respondWith(error("Cannot compile, errors found:"), listenerId);
    	for (<loc src, str msg> <- getErrors(typeEnv)) {
    		respondWith(text("[<src.path><line(src)>] <msg>"), listenerId);
    	}
    	return;
    }
    
    respondWith(clean(), listenerId);
    
    list[loc] compiledFiles = [];
    
    for (l <- ast, out := toPHPScript(newTransformEnv(config, ast), l.\module, ast), str outputFile <- out) {
    	compiledFiles += createSourceFile(outputFile, implode(toCode(out[outputFile])), config, listenerId);
    }
    
    map[loc, str] envFiles = generateEnvFiles(config, ast);
    
    for (f <- envFiles) {
    	respondWith(writeRemoteFile(f, envFiles[f]), listenerId);
    	compiledFiles += f;
    }
    
    createCompileLogFile(compiledFiles, listenerId);
    
    respondWith(info("Successfully compiled glagol project"), listenerId);
}

private str line(loc src) = ":<src.begin.line>" when src.begin? && src.begin.line?;
private str line(loc src) = "";

private void createCompileLogFile(list[loc] compiledFiles, int listenerId) {
	respondWith(writeRemoteLogFile(compiledFiles), listenerId);
}

private loc createSourceFile(str outputFile, str code, Config config, int listenerId) {
	loc file = |file:///| + "src" + outputFile;
	respondWith(writeRemoteFile(file, code), listenerId);
	
	return file;
}
