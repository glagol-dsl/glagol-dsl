module Utils::String

import String;

public str toLowerCaseFirstChar(str text) = toLowerCase(text[0]) + substring(text, 1);
public str toUpperCaseFirstChar(str text) = toUpperCase(text[0]) + substring(text, 1);
