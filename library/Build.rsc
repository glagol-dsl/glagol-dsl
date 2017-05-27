module Build

import IO;

public void main(list[str] args) {
    buildConverters();
}

private void buildConverters() {
    loc path = |cwd:///Parser/Converter|;
    
    str content 
        = "@doc=\"This is automatically generated file. Do not edit\"
        'module Parser::Converter
        'import Syntax::Abstract::Glagol;
        'import Syntax::Abstract::Glagol::Helpers;
        'import Syntax::Concrete::Grammar;
        'import Parser::ParseCode;
        'import Parser::Env;
        'import ParseTree;
        'import String;
        'import List;
        'import Set;
        'import Exceptions::ParserExceptions;
        '";
    
    for (file <- collectRascalSourcePaths(path)) {
        list[str] fileLines = readFileLines(file);
        
        for (fileLine <- fileLines, /^module/i !:= fileLine, /^import/i !:= fileLine) {
            content += "
            '<fileLine>";
        }
    };
    
    content += "\n";
    
    writeFile(|cwd:///Parser/Converter.rsc|, content);
    
    print("Generated ");
    println(|cwd:///Parser/Converter.rsc|.path);
}

private set[loc] collectRascalSourcePaths(loc root) {

    set[loc] sourcePaths = {};

    for (current <- root.ls) {
        if (current.extension == "rsc") {
            sourcePaths += current;
        } else if (isDirectory(current)) {
            try {
                current.ls;
                sourcePaths += collectRascalSourcePaths(current);
            } catch: ;
        }
    }
    
    return sourcePaths;
}
