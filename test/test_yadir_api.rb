require "test/unit"

require  'yadir/api.rb'
require  'yadir/auth.rb' 
require  'yadir/report.rb' 


class TestYadir < Test::Unit::TestCase
  def setup
    # Этот тест работает только с SSL авторизацией. 
   cert_dir=File.dirname(__FILE__)+"/../cert/"
   @connection=Yadir::Auth.new(:ssl,{cert_dir: cert_dir})
   @connection.start
   @yadir=Yadir::Api.new(@connection)
  end
  
  def teardown
    @connection.finish   
  end
  
  def test_request_for_report   
    @connection.debug=false
     
    @yadir.delete_all_reports! #очищаем список отчетов
    reports=@yadir.get_report_list
    assert_equal(0,reports.count)
    
        
    # формируем заказ на отчет, после этого проверяем что число доступных репортов увеличилось на 1
    campaign_id=2447901 #todo - когда научимся определять список кампаний - подставлять первую из списка
    start_date='2010-12-01'
    end_date='2010-12-31'
    new_rep_id=@yadir.create_new_report(campaign_id,start_date,end_date)

    reports=@yadir.get_report_list
    assert_instance_of(Array,reports,"Возвращены неверные данные") 
    assert_equal(1,reports.count)
    
    # загружаем сформированный отчет
    # проверяем, что в отчете - именно то, что нам нужно (структуру данных)
    
    ya_report=Yadir::Report.new(@connection,reports.first)
    ya_report.get_report
    refute_nil(ya_report,'ya_report should not be nil')
    
    #удаляем отчеты
    @yadir.delete_all_reports!
  end
  
end