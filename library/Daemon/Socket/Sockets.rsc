@license{
  Copyright (c) 2009-2015 CWI
  All rights reserved. This program and the accompanying materials
  are made available under the terms of the Eclipse Public License v1.0
  which accompanies this distribution, and is available at
  http://www.eclipse.org/legal/epl-v10.html
}
@contributor{Mark Hills - mhills@cs.ecu.edu (ECU)}
module Daemon::Socket::Sockets

@javaClass{org.glagol.socket.Sockets}
public java int createServerSocket(int port);

@javaClass{org.glagol.socket.Sockets}
public java void closeServerSocket(int serverSocketId);

@javaClass{org.glagol.socket.Sockets}
public java int createListener(int serverSocketId);

@javaClass{org.glagol.socket.Sockets}
public java void closeListener(int listenerId);

@javaClass{org.glagol.socket.Sockets}
public java str readFrom(int listenerId);

@javaClass{org.glagol.socket.Sockets}
public java void writeTo(int listenerId, str msg);

@javaClass{org.glagol.socket.Sockets}
public java void writeToAsASCII(int listenerId, str msg);
