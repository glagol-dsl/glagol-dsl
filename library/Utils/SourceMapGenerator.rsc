module Utils::SourceMapGenerator

import Utils::Base64VLQ;
import List;
import Set;
import lang::json::ast::JSON;
import lang::json::IO;
import IO;

alias Position = tuple[int line, int column];
alias Mapping = tuple[loc source, Position origin, Position generated, str name];
alias SourceMap = tuple[loc file, list[Mapping] mappings];

public SourceMap newSourceMap(loc file) = <file, []>;

public SourceMap addMapping(loc source, int originLine, int originColumn, int generatedLine, int generatedColumn, SourceMap m) = 
	addMapping(<source, <originLine, originColumn>, <generatedLine, generatedColumn>, "">, m);
	
public SourceMap addMapping(Mapping mapping, SourceMap m) = m[mappings = m.mappings + mapping];

public JSON sourceMapToJSON(SourceMap m) = object((
	"version": number(3.0),
	"sources": array([string(s) | s <- sortSources(m)]),
	"names": array([]),
	"file": string(m.file.path),
	"mappings": string(serializeMappings(m))
));

private list[str] sortSources(SourceMap m) = sort({mapping.source.path | mapping <- m.mappings});
private list[Mapping] sortMappings(list[Mapping] mappings) = sort(mappings, sortMapping);
private bool sortMapping(Mapping a, Mapping b) = a.generated.line == b.generated.line ? a.generated.column < b.generated.column : a.generated.line < b.generated.line;

private str serializeMappings(SourceMap m) = serializeMappings(sortMappings(m.mappings), sortSources(m));
private str serializeMappings(list[Mapping] mappings, list[str] sources) {
	str out = "";
	str next;
	int previousGeneratedLine = 1;
	int previousGeneratedColumn = 0;
	int previousOriginalColumn = 0;
	int previousOriginalLine = 0;
	int previousSource = 0;
	int sourceIdx = 0;
	Mapping mapping;
	
	for (int m <- index(mappings)) {
		mapping = mappings[m];
		next = "";
		if (mapping.generated.line != previousGeneratedLine) {
	        previousGeneratedColumn = 0;
	        while (mapping.generated.line != previousGeneratedLine) {
          		next = next + ";";
	          	previousGeneratedLine = previousGeneratedLine + 1;
	        }
	    } else {
		    if (m > 0) {
			    if (compareByGeneratedPositionsInflated(mapping, mappings[m - 1]) == 0) {
			        continue;
			    }
			    next = next + ",";
		    }
	  	}
	  	
	  	next = next + encode(mapping.generated.column - previousGeneratedColumn);
	  	
  		previousGeneratedColumn = mapping.generated.column;

    	sourceIdx = indexOf(sources, mapping.source.path);
    	next = next + encode(sourceIdx - previousSource);
    	previousSource = sourceIdx;

    	// lines are stored 0-based in SourceMap spec version 3
    	next = next + encode(mapping.origin.line - 1 - previousOriginalLine);

    	previousOriginalLine = mapping.origin.line - 1;

    	next = next + encode(mapping.origin.column - previousOriginalColumn);
    	previousOriginalColumn = mapping.origin.column;
    	
    	out = out + next;
  	}
  	
  	return out;
}

private int compareByGeneratedPositionsInflated(Mapping mappingA, Mapping mappingB) {
	int cmp = mappingA.generated.line - mappingB.generated.line;
	
	if (cmp != 0) {
    	return cmp;
  	}

  	cmp = mappingA.generated.column - mappingB.generated.column;
  	if (cmp != 0) {
  		return cmp;
  	}

  	cmp = strcmp(mappingA.source.path, mappingB.source.path);
  	if (cmp != 0) {
    	return cmp;
  	}

  	cmp = mappingA.origin.line - mappingB.origin.line;
  	if (cmp != 0) {
    	return cmp;
  	}

  	cmp = mappingA.origin.column - mappingB.origin.column;
  	if (cmp != 0) {
    	return cmp;
  	}

  return strcmp(mappingA.name, mappingB.name);
}

private int strcmp(str aStr1, str aStr2) {
	if (aStr1 == aStr2) {
    	return 0;
  	}

  	if (aStr1 == "") {
   		return 1;
  	}

  	if (aStr2 == "") {
    	return -1;
  	}

  	if (aStr1 > aStr2) {
    	return 1;
  	}

  	return -1;
}
