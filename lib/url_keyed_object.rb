module UrlKeyedObject
  # --
  # module-only methods
  # ++
  class << self
    # holds an array so a base-31 column (units / tens / hundreds) equiv can be 
    # encoded as an ASCII character
    def key_encoding
      @key_encoding ||= ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", 
                         "a", "b", "c", "d", "e", "f", "g", "h", "j", "k", "m",
                         "n", "p", "q", "r", "s", "v", "w", "x", "y", "z"]
    end
    
    # generates a url key from a random 5-digit base 31 number, without checking its uniqueness
    def generate_unchecked_url_key
      (1..5).collect do
        key_encoding[rand(31)]
      end.join('')
    end
    
    # Validate the well-formedness of a URL key
    def well_formed_url_key?(url_key)
      !url_key.match(/^[0-9abcdefghjkmnpqrsvwxyz]{5}$/).nil?
    end
    
    # decode a moderately dirty URL key
    def decode_url_key(url_key)
      url_key.downcase.tr('o', '0').tr('il', '1')
    end
  end
end

require 'url_keyed_object/active_record'
