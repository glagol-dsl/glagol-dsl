module BuildTests

import IO;
import Map;
import String;
import List;

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
    map[str function, loc location] functions = (function : file | file <- testFiles, line <- readFileLines(file), /test bool <function:.+?>\(\)/i := line);
    
    map[str f, int occurs] \all = distribution([function | file <- testFiles, line <- readFileLines(file), /test bool <function:.+?>\(\)/i := line]);
    
    for (str f <- \all, \all[f] > 1) {
    	println("<f> is duplicated");
    }
    
    str fnMap = ("" | it + "<f>:|<functions[f].uri>|," | f <- functions );

    str testAggregate = "module Tests
                        '
                        'import IO;
                        'import List;
                        'import Exception;
                        'import Map;
                        'import util::Math;
                        '<for (moduleName <- modules) {>import <moduleName>;
                        '<}>
                        '
                        'private list[str] errorMessages = [];
                        '
                        'private int testsPassed = 0;
                        '
                        'private void runTest(bool () t, loc location) {
                        '	bool isSuccessful;
                        '
                        '   try isSuccessful = t();
                        '   catch e: {
                        '       errorMessages +=  \"Test \<t\> threw an exception (located in \<location.path\>) with text \\\'\<e\>\\\'\";
                        '       isSuccessful = false;
                        '   }
                        '   
                        '   if (isSuccessful) {
                        '		print(\".\");
                        '	} else {
                        '       errorMessages += \"Test \<t\> failed in \<location.path\>\";
                        '       print(\"F\");
                        '   }
                        '
                        '   testsPassed += 1;
                        '
                        '   if (testsPassed % 30 == 0) println(\" \<toInt((toReal(testsPassed)/<toReal("<size(functions)>")>)*100)\>%\");
                        '} 
                        '
                        'public int main(list[str] args) {
                        '
                        '	testsPassed = 0;
                        '	errorMessages = [];
                        '   map[bool () fn, loc file] tests = (<substring(fnMap, 0, size(fnMap) - 1)>);
                        '
                        '   for (t \<- tests) {
                        '		try runTest(t, tests[t]);
                        '		catch e: errorMessages += e;
                        '	}
                        '
                        '	for (k \<- [0..(30 - testsPassed % 30)]) print(\" \");	
                        '
                        '   println(\" 100%\");
                        '
                        '   if (size(errorMessages) \> 0) {
                        '       println();
                        '       println(\"Not all tests passed:\");
                        '       for (error \<- errorMessages) println(error);
                        '   } else {
                        '       println(\"OK\");
                        '   }
                        '
                        '   println(\"Total tests: \<size(tests)\>, successful: \<size(tests) - size(errorMessages)\>, failed: \<size(errorMessages)\>\");
                        '
                        '   return size(errorMessages) \> 0 ? 1 : 0;
                        '}
                        '";

    writeFile(testsLoc.parent + "Tests.rsc", testAggregate);
}
