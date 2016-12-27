module Compiler::PHP::Glue

import List;

public str glue(list[str] pieces, _) = "" when size(pieces) == 0;
public str glue(list[str] pieces, _) = pieces[0] when size(pieces) == 1;
public str glue(list[str] pieces) = glue(pieces, "");
public default str glue(list[str] pieces, str d) = (pieces[0] | it + d + p | p <- slice(pieces, 1, size(pieces) - 1));
