module UrlKeyedObject
  # --
  # module-only methods
  # ++
  class << self
    # holds an array so a base-31 column (units / tens / hundreds) equiv can be 
    # encoded as an ASCII character
    def key_encoding
      @key_encoding ||= ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", 
                         "a", "b", "c", "d", "e", "f", "g", "h", "j", "k", 
                         "m", "n", "p", "q", "r", "s", "v", "w", "x", "y", 
                         "z"]
    end

    # generates a url key from a random 5-digit base 31 number, without checking its uniqueness
    def generate_unchecked_url_key(length = 5)
      (1..length).collect do
        key_encoding[rand(31)]
      end.join('')
    end

    # Keeps generating new URL keys until the passed-in block returns true
    def generate_checked_url_key(length = 5)
      key = generate_unchecked_url_key(length)
      while !yield(key)
        key = generate_unchecked_url_key(length)
      end
      key
    end

    # Validate the well-formedness of a URL key
    def well_formed_url_key?(url_key, length = 5)
      !url_key.match(Regexp.new("^[0-9abcdefghjkmnpqrsvwxyz]{#{length.to_i}}$")).nil?
    end

    # decode a moderately dirty URL key
    def decode_url_key(url_key)
      url_key.downcase.tr('o', '0').tr('il', '1')
    end

    # decode and validate a key, returning the decoded key only if it's well-formed
    def decode_well_formed_url_key(url_key, length = 5)
      decoded_url_key = decode_url_key(url_key)
      well_formed_url_key?(decoded_url_key, length) ? decoded_url_key : nil
    end
  end
end

if defined?(Rails::Railtie)
  require 'url_keyed_object/railtie' 
end

