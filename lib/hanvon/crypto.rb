module Hanvon
  class Crypto

    class InvalidPasswordException < StandardError; end

    attr_accessor :password

    def initialize(password)
      self.password = password
    end

    def convert(message, offset = 0)
      message.each_char.each_with_index.collect do |char, pos|
        convert_char(char, pos + offset)
      end.pack('C*')
    end

    alias_method :encrypt, :convert
    alias_method :decrypt, :convert

    def password=(password)
      if valid_password?(password)
        @password = password
        compute_key
      else
        raise InvalidPasswordException
      end
    end

    protected

    def convert_char(char, pos)
      return char.ord ^ @key[pos % 8]
    end

    def valid_password?(password)
      password =~ /\A\d{1,8}\z/
    end

    def compute_key
      @key = (0..7).collect do |pos|
        (password[pos] || 0).ord + (2 ** pos >> 1)
      end
    end

  end
end
