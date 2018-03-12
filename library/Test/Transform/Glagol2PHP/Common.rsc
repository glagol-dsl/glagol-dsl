module Test::Transform::Glagol2PHP::Common

import Transform::Glagol2PHP::Common;
import Syntax::Abstract::Glagol;

test bool shouldMakeFilenameFromNamespaceAndEntity()
    = "Some/Example/Entity/Test.php" == makeFilename(namespace("Some", namespace("Example", namespace("Entity"))), entity("Test", []));

test bool shouldMakeFilenameFromNamespaceAndAnnotatedEntity()
    = "Some/Example/Entity/Test.php" == makeFilename(namespace(
    	"Some", namespace("Example", namespace("Entity"))), entity("Test", [])[@annotations=[]]);

test bool shouldMakeFilenameFromNamespaceAndUtil()
    = "Some/Example/Util/Test.php" == makeFilename(namespace(
    	"Some", namespace("Example", namespace("Util"))), util("Test", [], notProxy()));

test bool shouldMakeFilenameFromNamespaceAndValueObject()
    = "Some/Example/VO/Test.php" == makeFilename(namespace(
    	"Some", namespace("Example", namespace("VO"))), valueObject("Test", [], notProxy()));

test bool shouldMakeFilenameFromNamespaceAndRepository()
    = "Some/Example/Repository/TestRepository.php" == makeFilename(namespace(
    	"Some", namespace("Example", namespace("Repository"))), repository("Test", []));

    
