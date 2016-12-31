module Daemon::Response

import Daemon::Socket::Sockets;
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
	
public void respondWith(list[Message] messages, int listenerId) {
	for (message <- messages) {
		respondWith(message, listenerId);
	}
}

public void respondWith(info(str msg, loc at), int listenerId) {
	respondWith(info("<msg> at <at>"), listenerId);
}

public void respondWith(error(str msg, loc at), int listenerId) {
	respondWith(error("<msg> at <at>"), listenerId);
}

public void respondWith(warning(str msg, loc at), int listenerId) {
	respondWith(warning("<msg> at <at>"), listenerId);
}

public void respondWith(info(str message), int listenerId) {
	writeTo(listenerId, toJSON(object(("type": string("info"), "args": array([string(message)])))));
}

public void respondWith(error(str message), int listenerId) {
	writeTo(listenerId, toJSON(object(("type": string("error"), "args": array([string(message)])))));
}

public void respondWith(warning(str message), int listenerId) {
	writeTo(listenerId, toJSON(object(("type": string("warning"), "args": array([string(message)])))));
}

public void respondWith(end(), int listenerId) {
	writeTo(listenerId, toJSON(object(("type": string("end")))));
}
