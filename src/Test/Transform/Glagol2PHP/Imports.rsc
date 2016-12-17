module Test::Transform::Glagol2PHP::Imports

import Syntax::Abstract::Glagol;
import Syntax::Abstract::PHP;
import Transform::Glagol2PHP::Imports;
import Config::Reader;

test bool shouldConvertToPhpUsesOnDoctrineEntityAndOverriding() =
	toPhpUses(
		[\import("Blah", namespace("Foo", namespace("Bar")), "Blah")], 
		entity("User", [
			constructor([], []),
			constructor([], []),
			constructor([], [])
		]), 
		<anyFramework(), doctrine()>) ==
	[phpUse({
		phpUse(phpName("Doctrine\\ORM\\Mapping"), phpSomeName(phpName("ORM"))),
		phpUse(phpName("Glagol\\Overriding\\Overrider"), phpNoName()),
		phpUse(phpName("Foo\\Bar\\Blah"), phpNoName())
	})]
	;

test bool shouldConvertToPhpUsesOnAnyORMEntityAndOverriding() =
	toPhpUses(
		[\import("Blah", namespace("Foo", namespace("Bar")), "Blah")], 
		entity("User", [
			constructor([], []),
			constructor([], []),
			constructor([], [])
		]), 
		<anyFramework(), anyORM()>) ==
	[phpUse({
		phpUse(phpName("Glagol\\Overriding\\Overrider"), phpNoName()),
		phpUse(phpName("Foo\\Bar\\Blah"), phpNoName())
	})]
	;

test bool shouldConvertToPhpUsesOnAnyORMEntityWithoutOverriding() =
	toPhpUses(
		[\import("Blah", namespace("Foo", namespace("Bar")), "Blah")], 
		entity("User", [
			constructor([], [])
		]), 
		<anyFramework(), anyORM()>) ==
	[phpUse({
		phpUse(phpName("Foo\\Bar\\Blah"), phpNoName())
	})]
	;
	
test bool shouldConvertToPhpUsesOnDoctrineEntityWithoutOverriding() =
	toPhpUses(
		[\import("Blah", namespace("Foo", namespace("Bar")), "Blah")], 
		entity("User", [
			constructor([], [])
		]), 
		<anyFramework(), doctrine()>) ==
	[phpUse({
		phpUse(phpName("Doctrine\\ORM\\Mapping"), phpSomeName(phpName("ORM"))),
		phpUse(phpName("Foo\\Bar\\Blah"), phpNoName())
	})]
	;
