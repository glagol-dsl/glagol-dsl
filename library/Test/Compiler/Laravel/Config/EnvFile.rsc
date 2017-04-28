module Test::Compiler::Laravel::Config::EnvFile

import Compiler::Laravel::Config::EnvFile;
import Syntax::Abstract::PHP;
import Compiler::Laravel::Config::Abstract;
import Compiler::PHP::Compiler;
import lang::json::ast::JSON;
import IO;

test bool shouldCreateLaravelEnvFile() {
    writeFile(|tmp:///config/database.json|, "{host: \"127.0.0.1\"}");

    bool result = createEnvFile(<object(()), |tmp:///|>) == "DB_HOST=127.0.0.1";
    
    remove(|tmp:///config/database.json|);
    
    return result;
}
