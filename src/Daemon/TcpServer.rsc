module Daemon::TcpServer

import IO;

@doc{
Used to create socket server. 
The second argument is a higher-order function should return output message for the connencted clients.
}
@javaClass{Daemon.TcpServer}
public java void createServer(int port, str (str incoming) messageHandler);