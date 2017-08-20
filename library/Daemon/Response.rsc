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
	| clean(loc file)
	| writeRemoteFile(loc file, str contents)
	| writeRemoteLogFile(loc file, list[loc] files)
	| deleteRemoteFile(loc file)
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
	writeTo(listenerId, toJSON(object(("type": string("info"), "message": string(message)))));
}

public void respondWith(text(str message), int listenerId) {
	writeTo(listenerId, toJSON(object(("type": string("plain_text"), "message": string(message)))));
}

public void respondWith(error(str message), int listenerId) {
	writeTo(listenerId, toJSON(object(("type": string("error"), "message": string(message)))));
}

public void respondWith(warning(str message), int listenerId) {
	writeTo(listenerId, toJSON(object(("type": string("warning"), "message": string(message)))));
}

public void respondWith(clean(loc file), int listenerId) {
	writeTo(listenerId, toJSON(object(("type": string("clean"), "file": string(file.path)))));
}

public void respondWith(writeRemoteFile(loc file, str contents), int listenerId) {
	writeTo(listenerId, toJSON(object(("type": string("create"), "file": string(file.path), "contents": string(contents)))));
}

public void respondWith(writeRemoteLogFile(loc file, list[loc] files), int listenerId) {
	writeTo(listenerId, toJSON(object(("type": string("create_log"), "file": string(file.path), "files": array([
		string(f.path) | f <- files
	])))));
}

public void respondWith(end(), int listenerId) {
	writeTo(listenerId, toJSON(object(("type": string("end")))));
}
