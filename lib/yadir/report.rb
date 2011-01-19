# gem xml-simple is required
require 'xmlsimple'

module Yadir
  
  # This is parser class for Yandex.Direct campaing stats reports
  class Report
    
    #After +get_report+ call this attribute contains array of hashes with rows of report 
    attr_accessor :report_data, 
    #After +get_report+ call this attribute contains number of report rows.
    attr_reader   :count
  
    # Creates a new Report object.
    #   You should pass an instance of Yadir::Auth class as a first parameter.
    #   You should pass a hash of Report params (this hash returned by Yadir::Api#get_report_list)
    def initialize(ya_auth,report_info)
      @status_report=report_info[:StatusReport]
      @report_id=report_info[:ReportID]
      @status_report=report_info[:StatusReport]
      @url=report_info[:Url]
    
      @ya_auth=ya_auth
    end
    
    # Retrieves and parses report.
    # Returns true if report retrieved and parsed. Else returns false.
    # Writes report data to ya_report.report_data attribute
    def get_report
      if @status_report=="Done" then
          @report_data=parse_report @ya_auth.get_request(@url)
          #TODO: если ya_auth==nil, то выбрасывать exception
          return true   #получили все успешно
        else
          return false # отчет не готов        
      end
    end
  
  private
    def parse_report(res_xml='')
      #возвращает (и сохраняет в @report_data) массив из хэшей, содержащих строчки отчета  
      @report_data=XmlSimple.xml_in(res_xml,{'KeyToSymbol'=>true}) 
      @report_data=@report_data[:stat].first
    
      @count=@report_data[:rows]
      @report_data=@report_data[:row]    
    end
  
  end
end