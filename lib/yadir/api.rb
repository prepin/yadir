require 'net/http'
require 'net/https'
require 'uri'
require 'json'
=begin rdoc
  - Use Yadir::Auth to create connection object. 
  - Use Yadir::Api to make Yandex.Direct API calls. 
  - Use Yadir::Report to parse campaing statistics report.
=end
module Yadir
  
  class Api  
  
  #Creates new Api object.
  #
  # You should pass an instance of Yadir::Auth class as a required parameter 
  #--
  #FIXME: Raise an exception if ya_auth is not instance of Yadir::Auth 
  #++    
  def initialize (ya_auth)
      @ya_auth=ya_auth
    end
  
    # Checks if Yandex.Direct API is available. 
    # Returns _true_ if it is responds correctly. Returns _false_ if test API call failed.
    # See more at Yandex: http://api.yandex.ru/direct/doc/reference/PingAPI.xml
    def ping_api
      res=api_call('PingAPI')
      if res[:data]==1
        res=true
      else
        res=false
      end
      res
    end
  
    # Requests +CreateNewReport+ API method.
    #   # Example:
    #   rep_id=yadir_api.create_new_report(2447901,'2010-12-01','2010-12-31')
    # Returns ID of created report
    #
    # See more at Yandex: http://api.yandex.ru/direct/doc/reference/CreateNewReport.xml
    #
    def create_new_report(campaign_id,start_date,end_date)
      new_report_info={ CampaignID: campaign_id,  StartDate: start_date, EndDate: end_date}
      res=api_call('CreateNewReport',new_report_info)[:data]
    end
  
  
    # Requests +GetReportList+ API method.
    #
    # Returns hash of currently available reports.
    #
    # See more at Yandex: http://api.yandex.ru/direct/doc/reference/GetReportList.xml
    #    
    def get_report_list
      res=api_call('GetReportList')[:data]
    end
    
    # Requests +DeleteReport+ API method.
    #
    # Returns true if report was succesfully deleted. Else returns false.
    # You should pass integer ID of report you willing to delete.
    #
    # See more at Yandex:http://api.yandex.ru/direct/doc/reference/DeleteReport.xml
    def delete_report(report_id)
      if api_call('DeleteReport',report_id)[:data]==1
        res=true
      else
        res=false
      end
      #api_call('DeleteReport')
    end
    
    # Deletes all previously created reports.
    def delete_all_reports!
      reports=get_report_list
      reports.each do |rep|
        rep[:ReportID]
        delete_report(rep[:ReportID])
      end
    end
    
    # Requests GetBalace method.
    # Returns hash of balances of chosen campaigns.
    # You should pass array of Campaign ID's (Integer)
    # See more at Yandex:http://api.yandex.ru/direct/doc/reference/GetBalance.xml
    def get_balance(campaigns=[])
      api_call("GetBalance",campaigns)
    end
      
  
  private

    # Performs call to chosen API +method+, passes params in +param+ parameter.
    # +method+ shoud be a String with method name
    # +param+ should be Hash of parameters.
    # Returns method responce as a Hash.
    def api_call(method='', param=nil)
      data= {
                method:         method,
                #token:          @token,
                #application_id: @application_id,
                #login:          @login
              }

        data[:param]=param if param
       
      res=@ya_auth.post_request(data)
    end
  
  end
end