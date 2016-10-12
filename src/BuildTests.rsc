module BuildTests

import IO;

private set[loc] collectTestFiles(loc location)
{
    set[loc] testFiles = {};

    for (current <- location.ls) {
        if (current.extension == "rsc") {
            testFiles += current;
        }
        else if (isDirectory(current)) {
            try {
                current.ls;
                testFiles += collectTestFiles(current);
            } catch: ;
        }
    }

    return testFiles;
}

public void main(list[str] args)
{
    loc testsLoc = |cwd:///Test|;

    testFiles = collectTestFiles(testsLoc);

    list[str] modules = [moduleName | file <- testFiles, line := readFileLines(file)[0], /module <moduleName:[a-zA-Z0-9:]+?>$/i := line];
    list[tuple[str function, str fileName]] functions = [<function, file.path> | file <- testFiles, line <- readFileLines(file), /test bool <function:.+?>\(\)/i := line];

    str testAggregate = "module Tests
                        '
                        'import IO;
                        'import List;
                        'import Exception;
                        '<for (moduleName <- modules) {>import <moduleName>;
                        '<}>
                        '
                        'public void main(list[str] args) {
                        '
                        '   list[str] errorMessages = [];
                        '
                        '<for (\test <- functions) {>
                        '   try {
                        '       if (<\test.function>()) print(\".\");
                        '       else {
                        '           errorMessages += \"Test <\test.function> failed in <\test.fileName>\";
                        '           print(\"F\");
                        '       }
                        '   } catch e: {
                        '       throw \"Test <\test.function> threw an exception (located in <\test.fileName>) with text \\\'\<e\>\\\'\";
                        '       return;
                        '   }
                        '<}>
                        '   if (size(errorMessages) \> 0) {
                        '       println();
                        '       println(\"Not all tests passed:\");
                        '       for (error \<- errorMessages) println(error);
                        '   } else println(\"OK\");
                        '}
                        '";

    writeFile(testsLoc.parent + "Tests.rsc", testAggregate);
}
