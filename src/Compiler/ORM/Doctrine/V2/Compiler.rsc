module Compiler::ORM::Doctrine::V2::Compiler

import Config::Reader;
import Syntax::Abstract::Glagol;
import Compiler::Commons::PhpCommons;
import String;
import IO;

public tuple[loc outputFile, str code] compileUnit(<_, doctrine(), loc projectPath, loc srcPath>, file(loc sourceFile, Declaration \module))
    = <getOutputFileName(sourceFile, \module, srcPath), compileFile(\module)>;

private loc getOutputFileName(loc sourceFile, Declaration ast, loc srcPath) {
    
    top-down visit (ast) {
        case entity(str name, _): return |tmp:///| + substring(sourceFile.parent.path, size(srcPath.path)) + "<name>.php";
    }
    
    return |tmp:///|;
}

private str compileFile(\module(Declaration namespace, set[Declaration] imports, Declaration artifact))
    = phpStart() 
    + nl()
    + phpNamespace(namespace)
    + nl()
    + phpImports(imports)
    + nl()
    + compileArtifact(artifact)
    + nl();
    
private str compileArtifact(entity(str name, set[Declaration] declarations))
    = "class <name>"
    + nl()
    + "{"
    + (nl() | compileDeclaration(declaration) + nl() | declaration <- declarations)
    + "}";
    
private str compileDeclaration(property(Type \valueType, str name, set[AccessProperty] valueProperties))
    = "private $<name>;";
