module Test::Utils::String

import Utils::String;

test bool shouldLowerCaseTheFirstLetterOfString()
    = toLowerCaseFirstChar("SomeText") == "someText" && toLowerCaseFirstChar("SomeOtherText") == "someOtherText" ;
