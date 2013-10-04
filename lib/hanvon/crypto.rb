module Hanvon
  class Crypto

    attr_accessor :password

    def initialize(password)
      self.password = password
    end

    def convert(message)
      message.each_char.each_with_index.collect do |char, pos|
        convert_char(char, pos)
      end.pack('C*')
    end

    alias_method :encrypt, :convert
    alias_method :decrypt, :convert

    def password=(password)
      @password = password
      compute_key
    end

    protected

    def convert_char(char, pos)
      return char.ord ^ @key[pos % 8]
    end

    def compute_key
      @key = (0..7).collect do |pos|
        (password[pos] || 0).ord + (2 ** pos >> 1)
      end
    end

  end
end
