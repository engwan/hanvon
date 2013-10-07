require 'socket'

module Hanvon
  class Client

    attr_accessor :host
    attr_accessor :port
    attr_accessor :password

    attr_accessor :socket
    attr_accessor :encryptor

    def initialize(host, port = 9922, password = nil)
      self.host = host
      self.port = port
      self.password = password

      self.socket = TCPSocket.new(host, port)
      self.encryptor = Crypto.new(password) unless password.nil?
    end

    def send(message)
      socket.write(encryptor ? encryptor.encrypt(message) : message)
      read_reply
    end

    def close
      socket.close
    end

    protected

    def read_reply
      reply = ""

      while true
        chunk = socket.recv(1024)
        reply += encryptor ? encryptor.decrypt(chunk, reply.length % 8) : chunk

        if reply[-1] == ')' and reply =~ /\A\w+\((?:\w+\s*=\s*".*"\s*)*\)\z/
          if reply.start_with?("Wait(")
            reply = ""
          else
            break
          end
        end
      end

      reply
    end

  end
end
