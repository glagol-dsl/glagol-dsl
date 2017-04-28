module Test::Compiler::PHP::ByRef

import Compiler::PHP::ByRef;

test bool shouldCompileByRefSign() = ref(true) == "&" && ref(false) == "";
