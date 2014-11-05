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

      addr = Socket.getaddrinfo(host, nil)
      sock = Socket.new(Socket.const_get(addr[0][0]), Socket::SOCK_STREAM, 0)

      timeout = [60, 0].pack("l_2")
      sock.setsockopt Socket::SOL_SOCKET, Socket::SO_RCVTIMEO, timeout
      sock.setsockopt Socket::SOL_SOCKET, Socket::SO_SNDTIMEO, timeout

      self.socket = sock
      self.encryptor = Crypto.new(password) unless password.nil?
    end

    def send_command(command, params = {})
      param_strings = []
      params.each { |k,v|
        param_strings << "#{k}=\"#{v}\""
      }

      send("#{command}(#{param_strings.join(" ")})")
    end

    def send(message)
      socket.write(encryptor ? encryptor.encrypt(message) : message)
      parse_reply(read_reply)
    end

    def parse_reply(reply)
      response = []

      response_data = reply.sub(/\AReturn\(/, "").chomp(")")
      response_data.split("\n").each_with_index { |r, i|
        row_hash = {}
        r.scan(/(\S+?)="(.*?)"/).each do |m|
          row_hash[m[0]] = m[1]
        end

        if i == 0
          row_hash.delete('result')
          row_hash.delete('dev_id')
        end

        response << row_hash unless row_hash.empty?
      }

      response = response.first if response.size == 1

      return response
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

        if reply[-1] == ')'
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
