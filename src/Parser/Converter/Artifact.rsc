module Parser::Converter::Artifact

import Syntax::Abstract::Glagol;
import Syntax::Abstract::Glagol::Helpers;
import Syntax::Concrete::Grammar;
import Parser::Converter::Declaration::Constructor;
import Parser::Converter::Declaration::Relation;
import Parser::Converter::Declaration::Method;
import Parser::Converter::Annotation;

public Declaration convertAnnotatedArtifact(a: (AnnotatedArtifact) `<Artifact artifact>`, list[Declaration] imports) = 
	convertArtifact(artifact, imports);
    
public Declaration convertAnnotatedArtifact(a: (AnnotatedArtifact) `<Annotation* annotations><Artifact artifact>`, list[Declaration] imports) = 
	convertArtifact(artifact, imports)[
    	@annotations = convertAnnotations(annotations)
    ];

public Declaration convertArtifact(a: (Artifact) `entity <ArtifactName name> {<Declaration* declarations>}`, list[Declaration] imports) = 
	entity("<name>", [convertDeclaration(d, "<name>", "entity") | d <- declarations])[@src=a@\loc];

public Declaration convertArtifact(a: (Artifact) `repository for <ArtifactName name> {<Declaration* declarations>}`, list[Declaration] imports) {
	if (!isImported("<name>", imports)) {
		throw EntityNotImported("Repository cannot attach to entity \'<name>\': entity not imported", a@\loc);
	}
	
    return repository("<name>", [convertDeclaration(d, "<name>", "repository") | d <- declarations])[@src=a@\loc];
}

public Declaration convertArtifact(a: (Artifact) `value <ArtifactName name> {<Declaration* declarations>}`, list[Declaration] imports) = 
	valueObject("<name>", [convertDeclaration(d, "<name>", "value") | d <- declarations])[@src=a@\loc];
    
public Declaration convertArtifact(a: (Artifact) `util <ArtifactName name> {<Declaration* declarations>}`, list[Declaration] imports) = 
	util("<name>", [convertDeclaration(d, "<name>", "util") | d <- declarations])[@src=a@\loc];
    
public Declaration convertArtifact(a: (Artifact) `service <ArtifactName name> {<Declaration* declarations>}`, list[Declaration] imports) = 
	util("<name>", [convertDeclaration(d, "<name>", "util") | d <- declarations])[@src=a@\loc];

public ControllerType convertControllerType(c: (ControllerType) `json-api`) = jsonApi()[@src=c@\loc];

public Route convertRoute(r: (RoutePart) `<Identifier part>`) = routePart("<part>")[@src=r@\loc];
public Route convertRoute(r: (RoutePart) `<RoutePlaceholder placeholder>`) = 
	routeVar(substring("<placeholder>", 1, size("<placeholder>")))[@src=r@\loc];

public Declaration convertArtifact(a: (Artifact) `<ControllerType controllerType>controller<{RoutePart "/"}* routes>{<Declaration* declarations>}`, list[Declaration] imports) = 
	controller(
		convertControllerType(controllerType), 
		route([convertRoute(r) | r <- routes]), 
		[convertDeclaration(d, "<name>", "controller") | d <- declarations]
	)[@src=a@\loc];
