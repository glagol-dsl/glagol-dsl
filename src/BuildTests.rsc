module BuildTests

import Prelude;

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

public int main(list[str] args)
{
    loc testsLoc = |cwd:///Test|;

    testFiles = collectTestFiles(testsLoc);

    list[str] functions = [function | file <- testFiles, line <- readFileLines(file), /test bool <function:.+?>\(\)/i := line];

    str testAggregate = "module Tests
                        '
                        'extend Test::All;
                        '
                        'public int main(list[str] args) {
                        '   list[bool] results = [];

                        '<for (function <- functions) {>
                        '   results += <function>();
                        '<}>
                        '   return false in results ? 1 : 0;
                        '}
                        '";

    writeFile(testsLoc.parent + "Tests.rsc", testAggregate);

    return 0;
}

