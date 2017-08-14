module Daemon::Response

import Daemon::Socket::Sockets;
import lang::json::IO;
import lang::json::ast::JSON;
import Message;

data Response
	= info(str message)
	| error(str message)
	| warning(str message)
	| text(str message)
	| end()
	;
	
public void respondWith(list[Message] messages, int listenerId) {
	for (message <- messages) {
		respondWith(message, listenerId);
	}
}

public void respondWith(info(str msg, loc at), int listenerId) {
	respondWith(info("<msg> in <at.path> on line <at.begin.line>, column <at.begin.column>"), listenerId);
}

public void respondWith(error(str msg, loc at), int listenerId) {
	if (at.begin?) {
		respondWith(error("<msg> in <at.path> on line <at.begin.line>, column <at.begin.column>"), listenerId);
	} else {
		respondWith(error("<msg> in <at.path>"), listenerId);
	}
}

public void respondWith(warning(str msg, loc at), int listenerId) {
	respondWith(warning("<msg> in <at.path> on line <at.begin.line>, column <at.begin.column>"), listenerId);
}

public void respondWith(info(str message), int listenerId) {
	writeTo(listenerId, toJSON(object(("type": string("info"), "args": array([string(message)])))));
}

public void respondWith(text(str message), int listenerId) {
	writeTo(listenerId, toJSON(object(("type": string("plain_text"), "args": array([string(message)])))));
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
