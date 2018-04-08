module Daemon::Response

import Daemon::Socket::Sockets;
import lang::json::IO;
import lang::json::ast::JSON;
import Message;

data Response
	= info(str message)
	| err(str message)
	| warning(str message)
	| text(str message)
	| clean()
	| writeRemoteFile(loc file, str contents)
	| writeRemoteLogFile(list[loc] files)
	| end()
	;
	
public void respondWith(list[Message] messages, int listenerId) {
	for (message <- messages) {
		respondWith(message, listenerId);
	}
}

public void respondWith(info(str message), int listenerId) {
	writeTo(listenerId, toJSON(object(("type": string("info"), "message": string(message)))));
}

public void respondWith(text(str message), int listenerId) {
	writeTo(listenerId, toJSON(object(("type": string("plain_text"), "message": string(message)))));
}

public void respondWith(err(str message), int listenerId) {
	writeTo(listenerId, toJSON(object(("type": string("error"), "message": string(message)))));
}

public void respondWith(warning(str message), int listenerId) {
	writeTo(listenerId, toJSON(object(("type": string("warning"), "message": string(message)))));
}

public void respondWith(clean(), int listenerId) {
	writeTo(listenerId, toJSON(object(("type": string("clean")))));
}

public void respondWith(writeRemoteFile(loc file, str contents), int listenerId) {
	writeTo(listenerId, toJSON(object(("type": string("create"), "file": string(file.path), "contents": string(contents)))));
}

public void respondWith(writeRemoteLogFile(list[loc] files), int listenerId) {
	writeTo(listenerId, toJSON(object(("type": string("create_log"), "files": array([
		string(f.path) | f <- files
	])))));
}

public void respondWith(end(), int listenerId) {
	writeTo(listenerId, toJSON(object(("type": string("end")))));
}
