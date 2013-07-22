@isTest
private class AppiaApiIntegration_Test {
	
	@isTest static void test_readXML() {
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
		xmlResponse +=  '<country>';
		xmlResponse +=  '<countryCode>AE</countryCode>';
		xmlResponse +=  '<campaigns>';
		xmlResponse +=  '<campaign>';
		xmlResponse +=  '<campaignId>563</campaignId>';
		xmlResponse +=  '<campaignName>Blood Brothers</campaignName>';
		xmlResponse +=  '<campaignDescription>BloodBrothers-CPI-354691-Tier2</campaignDescription>';
		xmlResponse +=  '<platform>Android</platform>';
		xmlResponse +=  '<impressions>370</impressions>';
		xmlResponse +=  '<clicks>8</clicks>';
		xmlResponse +=  '<installs>0</installs>';
		xmlResponse +=  '<revenue>0.00</revenue>';
		xmlResponse +=  '<clickThroughRatio>0.02</clickThroughRatio>';
		xmlResponse +=  '<costPerInstall>0.00</costPerInstall>';
		xmlResponse +=  '</campaign>';
		xmlResponse +=  '<campaign>';
		xmlResponse +=  '<campaignId>608</campaignId>';
		xmlResponse +=  '<campaignName>Bakery Story</campaignName>';
		xmlResponse +=  '<campaignDescription>BakeryStory-CPI-363553-SG-HK-IE-Multi</campaignDescription>';
		xmlResponse +=  '<platform>Android</platform>';
		xmlResponse +=  '<impressions>120</impressions>';
		xmlResponse +=  '<clicks>0</clicks>';
		xmlResponse +=  '<installs>0</installs>';
		xmlResponse +=  '<revenue>0.00</revenue>';
		xmlResponse +=  '<clickThroughRatio>0.00</clickThroughRatio>';
		xmlResponse +=  '<costPerInstall>0.00</costPerInstall>';
		xmlResponse +=  '</campaign>';
		xmlResponse +=  '<campaign>';
		xmlResponse +=  '<campaignId>1947</campaignId>';
		xmlResponse +=  '<campaignName>بوكر تكساس بويا</campaignName>';
		xmlResponse +=  '<campaignDescription>texas-poker-android-436386-uae-sa-kw</campaignDescription>';
		xmlResponse +=  '<platform>Android</platform>';
		xmlResponse +=  '<impressions>380</impressions>';
		xmlResponse +=  '<clicks>4</clicks>';
		xmlResponse +=  '<installs>0</installs>';
		xmlResponse +=  '<revenue>0.00</revenue>';
		xmlResponse +=  '<clickThroughRatio>0.01</clickThroughRatio>';
		xmlResponse +=  '<costPerInstall>0.00</costPerInstall>';
		xmlResponse +=  '</campaign>'; 
		xmlResponse +=  '</campaigns>';
		xmlResponse +=  '</country>';
		xmlResponse +=  '</countries>';
		xmlResponse +=  '</reportDate>';
		xmlResponse +=  '</report>';

		List<Publisher_Performance__c> prList = AppiaApiIntegration.getReportsList(xmlResponse);
		System.debug('prList has this value: ' + prList);

		System.assertEquals(true, !prList.isEmpty());
	}

	@isTest static void test_add2Reports() {
		Account acc = new Account(Name='Test Company');
		insert acc;

		/*Opportunity opp = new Opportunity(Name='Test Opp', AccountId=acc.Id, CloseDate=Date.today(), StageName='some stage');
		insert opp;*/

		Site__c site = new Site__c(Name='test Site', Account__c=acc.Id, Site_Id__c='555');
		insert site;

		Publisher_Performance__c pr1 = new Publisher_Performance__c(platform__c='iOS', clicks__c=10, impressions__c=20, installs__c=500, revenue__c=100000, Publisher__c=site.Id);
		insert pr1;

		Publisher_Performance__c pr2 = new Publisher_Performance__c(platform__c='iOS', clicks__c=3, impressions__c=5, installs__c=90, revenue__c=999, Publisher__c=site.Id);
		insert pr2;

		Publisher_Performance__c result = AppiaApiIntegration.add(pr1, pr2);

		System.assertEquals(100999, result.revenue__c);
	}
}