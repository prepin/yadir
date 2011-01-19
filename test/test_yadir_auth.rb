require "test/unit"

require  'yadir/api.rb'
require  'yadir/auth.rb' 
require  'oauth_test.rb'


class TestYadir < Test::Unit::TestCase
  
  def test_ssl_auth 
    #you must have valid certificates in your CERT_DIR
     cert_dir=File.dirname(__FILE__)+"/../cert/"
     connection=Yadir::Auth.new(:ssl,{cert_dir: cert_dir})
     connection.start
     yadir=Yadir::Api.new(connection)
     assert(yadir.ping_api,"Connection to Yandex.Direct API failed. SSL does not works")
     connection.finish 
  end
  
  def test_oauth_auth
    # your OAuth tokens must be valid
    connection=Yadir::Auth.new(:oauth,OAUTH_TOKEN)
    connection.start
    yadir=Yadir::Api.new(connection)
    assert(yadir.ping_api,"Connection to Yandex.Direct API failed. OAuth does not works")
    connection.finish
  end  
  
end