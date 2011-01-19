module Yadir
  class Auth

    YANDEX_DIRECT_API_V3='https://soap.direct.yandex.ru/json-api/v3/'
    #Set debug value to +true+, if you want to see incoming and outcoming JSON.    
    attr_accessor :debug
    
    # Creates new connection to API object.
    # 
    # You have two options.
    #  SSL (preferable) - you should pass a path to yandex certificates directory.
    #  #SSL auth example
    #  connection=Yadir::Auth.new(:ssl,{cert_dir: "/home/ya_certs"})
    # 
    #  OAuth - you should pass your token, application ID and user name
    #  connection=Yadir::Auth.new(:oauth,{token: "f850c282732a4b404a2f662da7bdf7c5", application_id:"66da1738d28c4fd3ac76abf3673a47a9",login:"mylogin"})
    # 
    # See how to get your SSL certificates or OAuth token at http://api.yandex.ru/direct/doc/concepts/Authorize.xml  
    def initialize (auth_method=:ssl,params={})

      if auth_method==:ssl
        @cert_file = File.read(File.join(params[:cert_dir], "cert.crt"))
        @key_file= File.read(File.join(params[:cert_dir], "private.key"))
      elsif auth_method==:oauth
        @token=params[:token]
        @application_id=params[:application_id]
        @login=params[:login]
      end

      @auth_method=auth_method
      @request_uri=URI.parse(YANDEX_DIRECT_API_V3)       
      @debug=false  
    end
    
    # Starts a new session 
    def start
      @http_session = Net::HTTP.new(@request_uri.host, @request_uri.port)
      if @auth_method==:ssl
        @http_session.cert = OpenSSL::X509::Certificate.new(@cert_file)    
        @http_session.key = OpenSSL::PKey::RSA.new(@key_file)
      end
      
      @http_session.use_ssl=true
      @http_session.verify_mode = OpenSSL::SSL::VERIFY_NONE
      @http_session.start
    end
    
    # Closes a session
    def finish
      @http_session.finish
    end

    # Sends a GET HTTP request to +url+ (SSL authorized if possible)
    def get_request (url='')
      res=@http_session.get(url).body

      if @debug then
        puts res
      end

      res
    end

    # Sends a POST HTTP request to API server
    # +param+ hash is transformed to JSON
    # if debug enabled, outputs request and responce to STDOUT
    # Returns a server responce as a hash.
    def post_request(param)
      param=add_oauth_data(param)
      
      data_json=JSON.generate(param)
      
      res=@http_session.post(@request_uri.path,data_json).body

      if @debug then
        puts "DEBUG INFO..."
        puts "Request in JSON:"
        puts data_json
        puts "Server Responce:"
        puts res
        puts "End of DEBUG INFO..."
        
      end
      res=JSON.parse(res,:symbolize_names => true)          
    end
    
  private
    def add_oauth_data(data)
      if @auth_method==:oauth
        data=data.merge ({token: @token, application_id: @application_id,login: @login})
      end
      data
    end

  end
end