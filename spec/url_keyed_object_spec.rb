require 'spec_helper'

describe UrlKeyedObject do
  it "should be able to generate a 5-character URL key" do
    UrlKeyedObject.generate_unchecked_url_key.should match(/[0-9abcdefghjkmnpqrsvwxyz]{5}/)
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
  end
end