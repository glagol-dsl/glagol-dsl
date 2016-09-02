module Daemon::Compile

import Daemon::TcpServer;
import lang::json::IO;
import lang::json::ast::JSON;
import IO;

private alias Command = tuple[str command, loc path, bool isFile];

public void listenForCompileSignals(int port) {
    openSocket(port, compileController);
}

private void compileController(str inputStream) {

    if (inputStream == "quit") return;
        
    try {
        Command command = decodeJSON(inputStream);
        dispatchCommand(command);
    } catch e: {
        socketWriteLn("Invalid JSON");
    }
}

private void dispatchCommand(Command command) {
    switch (command.command) {
        case "compile":
            socketWriteLn("It will compile some day");
    }
}

private Command decodeJSON(str inputStream) {

    JSON json = fromJSON(#JSON, inputStream);    
    loc path = |file:///| + json.properties["path"].s;
    
    return <json.properties["command"].s, path, isFile(path)>;
}
