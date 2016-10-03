module Daemon::Compile

import Daemon::TcpServer;
import Compiler::Compiler;
import lang::json::IO;
import lang::json::ast::JSON;
import IO;

private alias Command = tuple[str command, loc path];

public void listenForCompileSignals(int port) {
    openSocket(port, controller);
}

private void controller(str inputStream) {

    if (inputStream == "quit") return;
        
    try {
        Command command = decodeJSON(inputStream);
        dispatch(command);
    } catch e: {
        socketWriteLn("Invalid JSON");
    }
}

private void dispatch(Command command) {
    switch (command.command) {
        case "compile":
            compile(command.path);
    }
}

private Command decodeJSON(str inputStream) {

    JSON json = fromJSON(#JSON, inputStream);    
    loc path = |file:///| + json.properties["path"].s;
    
    return <json.properties["command"].s, path, isFile(path), json.properties["orm"].s>;
}
