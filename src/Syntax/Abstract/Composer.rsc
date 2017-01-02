module Syntax::Abstract::Composer

public data Config
    = root(list[ComposerConfig] properties)
    | name(str name)
    | description(str name)
    | version(str version)
    | \type(str \type)
    | keywords(list[str] keywords)
    | homepage(loc url)
    | time(datetime time)
    | license(str license)
    | license(list[str] licenses)
    | authors(list[Author] authors)
    | support(map[str, str] supportProps)
    | minStability(Stability stability)
    | require(map[str, str] packageLinks)
    | requireDev(map[str, str] packageLinks)
    | conflict(map[str, str] packageLinks)
    | replace(map[str, str] packageLinks)
    | provide(map[str, str] packageLinks)
    | suggest(map[str, str] packageLinks)
    ;

public data Stability = dev() | alpha() | beta() | RC() | stable();

public data Author = author(map[str, str] properties);
