require 'spec_helper'

describe UrlKeyedObject do
  it "should be able to generate a 5-character URL key" do
    UrlKeyedObject.generate_unchecked_url_key.should match(/[0-9abcdefghjkmnpqrsvwxyz]{5}/)
  end
  
  it "should be able to generate an arbitrary-length URL key" do
    UrlKeyedObject.generate_unchecked_url_key(7).should match(/[0-9abcdefghjkmnpqrsvwxyz]{7}/)
  end
  
  describe "decoding a moderately dirty URL key (case insensitivity, ambiguous character replacement)" do
    it "should be able to cope with O o 0 ambiguity" do
      UrlKeyedObject.decode_url_key('Oo0ab').should == '000ab'
    end
    
    it "should be able to cope with 1 I i L l ambiguity" do
      UrlKeyedObject.decode_url_key('1IiLl').should == '11111'
    end
    
    it "should be able to cope with uppercase" do
      UrlKeyedObject.decode_url_key('ABCDE').should == 'abcde'
    end
  end
  
  describe "well-formedness of URL keys" do
    it "should be able to confirm that a URL key is well-formed" do
      UrlKeyedObject.well_formed_url_key?('0ab9d').should be_true
    end
    
    it "should report that malformed URL keys are NOT well-formed" do
      ['DfZZZ', # upper case
       'abcdef', # too long
       'iabcd', # ambiguous character
       'tabcd', # ambiguous character
       'uabcd', # ambiguous character
       '_abcd', # illegal character
       'ab,cd', # illegal character
       'ab.cd', # illegal character
      ].each do |malformed_url_key|
        UrlKeyedObject.well_formed_url_key?(malformed_url_key).should be_false
      end
    end
    
    it "should be able to cope with a different specified length" do
      UrlKeyedObject.well_formed_url_key?('abcdef', 6).should be_true
    end
  end
  
  describe "validity of URL keys" do
    it "should be able to evaluate a block to check key validity, repeating until it generates one" do
      valid_key_sequence = sequence('valid key sequence')
      UrlKeyedObject.expects(:generate_unchecked_url_key).with(5).returns('a1url').
                     in_sequence(valid_key_sequence)
      UrlKeyedObject.expects(:generate_unchecked_url_key).with(5).returns('a2url').
                     in_sequence(valid_key_sequence)
      
      key = UrlKeyedObject.generate_checked_url_key { |value| value != 'a1url' }
      
      key.should == 'a2url'
    end
    
    it "should description" do
      
    end
  end
end