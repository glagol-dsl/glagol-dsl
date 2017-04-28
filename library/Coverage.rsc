module Coverage

import IO;
import String;
import List;
import Set;
import util::Math;

int main([str command, *value R]) {

    loc baseLoc = |cwd:///|;

    set[loc] srcFiles = collectSrcFiles(
        baseLoc, 
        baseLoc + "Test", 
        baseLoc + "Tests.rsc", 
        baseLoc + "BuildTests.rsc", 
        baseLoc + "Build.rsc", 
        baseLoc + "Parser/Converter",
        baseLoc + "Parser/Converter.rsc",
        baseLoc + "Coverage.rsc",
        baseLoc + "Syntax/Concrete",
        baseLoc + "Syntax/Abstract/Glagol.rsc",
        baseLoc + "Syntax/Abstract/PHP.rsc"
    );
    
    set[loc] testFiles = collectSrcFiles(baseLoc + "Test");
    
    switch (command) {
        case "report": report(testFiles, srcFiles, baseLoc);
        case "create-next": createNext(testFiles, srcFiles, baseLoc);
        default: {
            println("Command \"<command>\" does not exist. Here are the supported commands:");
            println("\treport\t\tPrint test coverage report");
            println("\tcreate-next\tWill create test file for the next not covered source file");
        }
    }
    
    return 0;
}

private void createNext(set[loc] testFiles, set[loc] srcFiles, loc baseLoc) {
    for (f <- sort(toStrList(srcFiles, baseLoc) - [srcFile | f <- toStrList(testFiles, baseLoc), /Test\/<srcFile:.+?\.rsc>/ := f])) {
        writeFile(baseLoc + "Test" + f, 
            "module Test::<toModule(f)>" +
            "\n\n" +
            "import <toModule(f)>;\n\n");
        println("Created empty test <toModule("Test/" + f)>");
        break;
    }
}

private str toModule(str file) = replaceLast(replaceAll(file, "/", "::"), ".rsc", "");

private void report(set[loc] testFiles, set[loc] srcFiles, loc baseLoc) {
    println("List of modules without coverage:");
    
    for (f <- sort(toStrList(srcFiles, baseLoc) - [srcFile | f <- toStrList(testFiles, baseLoc), /Test\/<srcFile:.+?\.rsc>/ := f])) {
        println(toModule(f));
    }
}

private real getCoverageRation(list[loc] testFiles, list[loc] srcFiles) = 
    precision((toReal(size(testFiles))/toReal(size(srcFiles)))*100.0, 4);

private list[str] toStrList(set[loc] files, loc baseLoc) = [replaceAll(f.uri, baseLoc.uri, "") | f <- files];

private set[loc] collectSrcFiles(loc location, loc exclude...)
{
    set[loc] testFiles = {};

    for (current <- location.ls, current notin exclude) {
        if (current.extension == "rsc") {
            testFiles += current;
        }
        else if (isDirectory(current)) {
            try {
                current.ls;
                testFiles += collectSrcFiles(current, exclude);
            } catch: ;
        }
    }

    return testFiles;
}
