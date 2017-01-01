module Parser::Converter::Artifact

import Syntax::Abstract::Glagol;
import Syntax::Abstract::Glagol::Helpers;
import Syntax::Concrete::Grammar;
import Parser::Converter::Declaration::Constructor;
import Parser::Converter::Declaration::Relation;
import Parser::Converter::Declaration::Method;
import Parser::Converter::Annotation;

@todo="Optimize syntax to use less converters, generalize annotations"
public Declaration convertArtifact(a: (Artifact) `entity <ArtifactName name> {<Declaration* declarations>}`, list[Declaration] imports)
    = entity("<name>", [convertDeclaration(d, "<name>", "entity") | d <- declarations])[@src=a@\loc];

public Declaration convertArtifact(a: (Artifact) `<Annotation* annotations> entity <ArtifactName name> {<Declaration* declarations>}`, list[Declaration] imports) 
    = entity("<name>", [convertDeclaration(d, "<name>", "entity") | d <- declarations])[
    	@annotations=convertAnnotations(annotations)
    ][@src=a@\loc];

public Declaration convertArtifact(a: (Artifact) `repository for <ArtifactName name> {<Declaration* declarations>}`, list[Declaration] imports) {
	if (!isImported("<name>", imports)) {
		throw EntityNotImported("Repository cannot attach to entity \'<name>\': entity not imported", a@\loc);
	}
	
    return repository("<name>", [convertDeclaration(d, "<name>", "repository") | d <- declarations])[@src=a@\loc];
}

public Declaration convertArtifact(a: (Artifact) `<Annotation* annotations> repository for <ArtifactName name> {<Declaration* declarations>}`, list[Declaration] imports) {
	if (!isImported("<name>", imports)) {
		throw EntityNotImported("Repository cannot attach to entity \'<name>\': entity not imported", a@\loc);
	}
	
	return repository("<name>", [convertDeclaration(d, "<name>", "repository") | d <- declarations])[
    	@annotations = convertAnnotations(annotations)
    ][@src=a@\loc];
}

public Declaration convertArtifact(a: (Artifact) `value <ArtifactName name> {<Declaration* declarations>}`, list[Declaration] imports)
    = valueObject("<name>", [convertDeclaration(d, "<name>", "value") | d <- declarations])[@src=a@\loc];
    
public Declaration convertArtifact(a: (Artifact) `<Annotation* annotations> value <ArtifactName name> {<Declaration* declarations>}`, list[Declaration] imports) 
    = valueObject("<name>", [convertDeclaration(d, "<name>", "util") | d <- declarations])[
    	@annotations = convertAnnotations(annotations)
    ][@src=a@\loc];
    
public Declaration convertArtifact(a: (Artifact) `util <ArtifactName name> {<Declaration* declarations>}`, list[Declaration] imports)
    = util("<name>", [convertDeclaration(d, "<name>", "util") | d <- declarations])[@src=a@\loc];
    
public Declaration convertArtifact(a: (Artifact) `<Annotation* annotations> util <ArtifactName name> {<Declaration* declarations>}`, list[Declaration] imports) 
    = util("<name>", [convertDeclaration(d, "<name>", "util") | d <- declarations])[
    	@annotations = convertAnnotations(annotations)
    ][@src=a@\loc];
    
public Declaration convertArtifact(a: (Artifact) `service <ArtifactName name> {<Declaration* declarations>}`, list[Declaration] imports)
    = util("<name>", [convertDeclaration(d, "<name>", "util") | d <- declarations])[@src=a@\loc];
    
public Declaration convertArtifact(a: (Artifact) `<Annotation* annotations> service <ArtifactName name> {<Declaration* declarations>}`, list[Declaration] imports) 
    = util("<name>", [convertDeclaration(d, "<name>", "util") | d <- declarations])[
    	@annotations = convertAnnotations(annotations)
    ][@src=a@\loc];
    
