module Parser::Converter::Stringifier

public str stringify((MemberName) `<MemberName id>`) = stringify("<id>");
public str stringify((Identifier) `<Identifier id>`) = stringify("<id>");

public str stringify(str id) = substring(id, 1) when id[0] == "\\";
public default str stringify(str id) = id;
