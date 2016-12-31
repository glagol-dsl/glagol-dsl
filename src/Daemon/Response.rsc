module Daemon::Response

import Daemon::TcpServer;
import lang::json::IO;
import lang::json::ast::JSON;
import Message;

// TODO use Message
data Response
	= info(str message)
	| error(str message)
	| warning(str message)
	| end()
	;
	
public void respondWith(list[Message] messages) {
	for (message <- messages) {
		respondWith(message);
	}
}

public void respondWith(info(str msg, loc at)) {
	respondWith(info("<msg> at <at>"));
}

public void respondWith(error(str msg, loc at)) {
	respondWith(error("<msg> at <at>"));
}

public void respondWith(warning(str msg, loc at)) {
	respondWith(warning("<msg> at <at>"));
}

public void respondWith(info(str message)) {
	socketWriteLn(toJSON(object(("type": string("info"), "args": array([string(message)])))));
}

public void respondWith(error(str message)) {
	socketWriteLn(toJSON(object(("type": string("error"), "args": array([string(message)])))));
}

public void respondWith(warning(str message)) {
	socketWriteLn(toJSON(object(("type": string("warning"), "args": array([string(message)])))));
}

public void respondWith(end()) {
	socketWriteLn(toJSON(object(("type": string("end")))));
}
