module Test::Utils::SourceMapGenerator

import Utils::SourceMapGenerator;
import lang::json::IO;

test bool shouldGenerateSourceMapFromMappings() = 
	toJSON(sourceMapToJSON(addMapping(|tmp:///origin.php|, 1, 0, 3, 0, addMapping(|tmp:///origin.php|, 1, 6, 3, 4, newSourceMap(|tmp:///source.g|))))) ==
	"{\"mappings\":\";;AAAA,IAAM\",\"names\":[],\"file\":\"/source.g\",\"version\":3.0,\"sources\":[\"/origin.php\"]}";
