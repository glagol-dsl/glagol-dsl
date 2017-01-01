module Daemon::Compile

import Daemon::Response;
import Compiler::Compiler;
import lang::json::IO;
import lang::json::ast::JSON;
import IO;
import String;
import Parser::ParseCode;
import Ambiguity;
import Message;
import Daemon::Socket::Sockets;
import Exceptions::ParserExceptions;
import Exceptions::ConfigExceptions;
import Exceptions::TransformExceptions;

private alias Command = tuple[str command, loc path];

public int main(list[str] args) {

	println("Opening socket...");
	
	int socketId = createServerSocket(toInt(args[0]));
	
	listenForCompileSignals(socketId);
	
    closeServerSocket(socketId);
    
    return 0;
}

public void listenForCompileSignals(int socketId) {
	int listenerId = createListener(socketId);
    
    controller(readFrom(listenerId), listenerId);
    
    closeListener(listenerId);
    
    listenForCompileSignals(socketId);
}

private void controller(str inputStream, int listenerId) {

    if (inputStream == "quit") return;
        
    try {
        Command command = decodeJSON(inputStream);
        dispatch(command, listenerId);
    } catch Ambiguity(loc file, _, _): {
        respondWith(diagnose(parseCode(|file:///| + file.path, true)), listenerId);
    } catch ParseError(loc location): {
    	respondWith(error(
    		"Parse error at <location.path> starting on line <location.begin.line>, column <location.begin.column> " +
    		"and ends on line <location.end.line>, column <location.end.column>."
		), listenerId);
	} catch ConfigException e: {
		respondWith(error(e.msg), listenerId);
	} catch ParserException e: {
		respondWith(error(e.msg, e.at), listenerId);
    } catch TransformException e: {
		respondWith(error(e.msg, e.at), listenerId);
    } catch e: {
    	respondWith(error("Error: <e>"), listenerId);
    }
    respondWith(end(), listenerId);
}

private void dispatch(Command command, int listenerId) {
    switch (command.command) {
        case "compile":
            compile(command.path, listenerId);
    }
}

private Command decodeJSON(str inputStream) {
    JSON json = fromJSON(#JSON, inputStream);
    
    return <json.properties["command"].s, |file:///| + json.properties["path"].s>;
}
