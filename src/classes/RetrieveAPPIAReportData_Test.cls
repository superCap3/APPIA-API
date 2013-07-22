/**
	©MadronaSG 
	
	Test class for the RetrieveAPPIAReportData.cls

	11.July.2013/Adrian: 	created the class
*/
	
@isTest
private class RetrieveAPPIAReportData_Test {
	
	@isTest static void test_startTheScheduler() {
		Test.StartTest();
		//we create 1 Site
		Account acc = new Account(Name='Test Company');
		insert acc;

		Site__c site = new Site__c(Name='test Site', Account__c=acc.Id, Site_Id__c='555');
		insert site;

		//we create one fake response xml
		String xmlResponse = '<report>';
		xmlResponse +=  '<reportDate>';
		xmlResponse +=  '<date>2013-07-12</date>';
		xmlResponse +=  '<countries>';
		xmlResponse +=  '<country>';
		xmlResponse +=  '<countryCode>AD</countryCode>';
		xmlResponse +=  '<campaigns>';
		xmlResponse +=  '<campaign>';
		xmlResponse +=  '<campaignId>614</campaignId>';
		xmlResponse +=  '<campaignName>Petshop Story</campaignName>';
		xmlResponse +=  '<campaignDescription>Petshop-CPI-363554-ROW</campaignDescription>';
		xmlResponse +=  '<platform>Android</platform>';
		xmlResponse +=  '<impressions>20</impressions>';
		xmlResponse +=  '<clicks>0</clicks>';
		xmlResponse +=  '<installs>0</installs>';
		xmlResponse +=  '<revenue>0.00</revenue>';
		xmlResponse +=  '<clickThroughRatio>0.00</clickThroughRatio>';
		xmlResponse +=  '<costPerInstall>0.00</costPerInstall>';
		xmlResponse +=  '</campaign>';
		xmlResponse +=  '</campaigns>';
		xmlResponse +=  '</country>';
		xmlResponse +=  '</countries>';
		xmlResponse +=  '</reportDate>';
		xmlResponse +=  '</report>';

		// RestClientHTTPMocks(Integer code, String status, String body, Map<String, String> responseHeaders)
		RestClientHTTPMocks fakeResponse = new RestClientHTTPMocks(200, 'Success', xmlResponse, new Map<String,String>());
		
		Test.setMock(HttpCalloutMock.class, fakeResponse);

		RetrieveAPPIAReportData rard = new RetrieveAPPIAReportData();
		rard.execute(null);

		Test.StopTest();

		List<Publisher_Performance__c> ppList = [SELECT Id FROM Publisher_Performance__c WHERE Publisher__c=:site.Id];
		System.debug('ppList has this value: ' + ppList);

		//System.AssertEquals(1, ppList.size());
	}
	
	
}