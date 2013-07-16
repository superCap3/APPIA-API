@isTest
private class AppiaApiIntegration_Test {
	
	@isTest static void test_method_one() {
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

		AppiaApiIntegration aai = new AppiaApiIntegration();
		List<Publisher_Performance__c> prList = aai.getReportsList(xmlResponse);
		System.debug('prList has this value: ' + prList);

		System.assertEquals(true, !prList.isEmpty());

	}
	
}