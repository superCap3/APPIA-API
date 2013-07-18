/**
	©MadronaSG 
	
	Helper class for the RetrieveSiteDailyDataBatch.cls. 
	Main task of the class is to take the response from the APPIA API - a XML String - and parse it into a list of Publisher_Performance__c
	Fields mapped for the matching are:
	- campaignDescription__c (Text 255)
	- campaignId__c (Text 18)
	- campaignName__c (Text 255)
	- clicks__c (number 18)
	- countryCode__c (Text 2)
	- Date__c (Date)
	- impressions__c (number 18)
	- installs__c (number 18)
	- platform__c (Picklist)
	- revenue__c (Currency 18)
	- Publisher__c Master-Detail(Site) 

	12.July.2013/Adrian: 	created the class
*/

public class AppiaApiIntegration {

	public static List<Publisher_Performance__c> getReportsList(String xmlResponse) {
		List<Publisher_Performance__c> prList = new List<Publisher_Performance__c>();
		DOM.Document doc = new DOM.Document();      
	  	try {
	    	doc.load(xmlResponse);
	    	    
	    	DOM.XMLNode root = doc.getRootElement();
			//System.debug('root has this value: ' + root);
	
	    	if (root.getChildElement('reportDate', null) != null) {
	    		root = root.getChildElement('reportDate', null);
	    		//System.debug('root has this value: ' + root);
	    		if (root.getChildElement('countries', null) != null) {
	    			root = root.getChildElement('countries', null);
	    			//System.debug('root has this value: ' + root);

	    			for (DOM.XMLNode country: root.getChildren()) {
	    				//System.debug('country has this value: ' + country);
	    				String countryCode = '';

	    				for (DOM.XMLNode countryElement: country.getChildren()) {
		    				if ((countryElement.getNodeType() == DOM.XMLNodeType.ELEMENT) && (countryElement.getName() == 'countryCode')) {
		    					countryCode = countryElement.getText();
		    					System.debug('countryCode has this value: ' + countryCode);
		    				} 
		    				if ((countryElement.getNodeType() == DOM.XMLNodeType.ELEMENT) && (countryElement.getName() == 'campaigns')) {
		    					for (Dom.XMLNode campaign: countryElement.getChildElements()) {
		    						if ((campaign.getNodeType() == DOM.XMLNodeType.ELEMENT) && (campaign.getName() == 'campaign')) {
		    							Publisher_Performance__c reportData = getCampaignInfo(campaign);
		    							reportData.countryCode__c = countryCode;
		    							reportData.Date__c = Date.today().addDays(-1);
		    							
		    							System.debug('reportData has this value: ' + reportData);
										prList.add(reportData);
		    						}
		    					}
		    				}
		    			}
	    			}
	    		}
	    	}
	    } catch (System.XMLException e) {  // invalid XML
	    	System.debug('xml crashed with this error: ' + e.getMessage());
	    	return null;
	    }

		System.debug('prList has this value: ' + prList);
		return prList;
	}

	public static Publisher_Performance__c getCampaignInfo(DOM.XMLNode node) {
		Publisher_Performance__c reportData = new Publisher_Performance__c();
		for (Dom.XMLNode child: node.getChildElements()) {
			if ((child.getNodeType() == DOM.XMLNodeType.ELEMENT) && (child.getName() == 'campaignId')) {
				reportData.campaignId__c = child.getText();
			}
			if ((child.getNodeType() == DOM.XMLNodeType.ELEMENT) && (child.getName() == 'campaignName')) {
				reportData.campaignName__c = child.getText();
			}
			if ((child.getNodeType() == DOM.XMLNodeType.ELEMENT) && (child.getName() == 'campaignDescription')) {
				reportData.campaignDescription__c = child.getText();
			}
			if ((child.getNodeType() == DOM.XMLNodeType.ELEMENT) && (child.getName() == 'platform')) {
				reportData.platform__c = child.getText();
			}
			if ((child.getNodeType() == DOM.XMLNodeType.ELEMENT) && (child.getName() == 'clicks')) {
				reportData.clicks__c = Decimal.valueOf(child.getText());
			}
			if ((child.getNodeType() == DOM.XMLNodeType.ELEMENT) && (child.getName() == 'impressions')) {
				reportData.impressions__c = Decimal.valueOf(child.getText());
			}
			if ((child.getNodeType() == DOM.XMLNodeType.ELEMENT) && (child.getName() == 'installs')) {
				reportData.installs__c = Decimal.valueOf(child.getText());
			}
			if ((child.getNodeType() == DOM.XMLNodeType.ELEMENT) && (child.getName() == 'revenue')) {
				reportData.revenue__c = Decimal.valueOf(child.getText());
			}
		}

		System.debug('reportData inside the getCampaignInfo has this value: ' + reportData);
		return reportData; 
	}

	public static Publisher_Performance__c add(Publisher_Performance__c pr1, Publisher_Performance__c pr2) {
		Publisher_Performance__c result = new Publisher_Performance__c();
		result.Publisher__c = pr1.Publisher__c;
		result.platform__c = pr1.platform__c;
		result.clicks__c = pr1.clicks__c + pr2.clicks__c;
		result.impressions__c = pr1.impressions__c + pr2.impressions__c;
		result.installs__c = pr1.installs__c + pr2.installs__c;
		result.revenue__c = pr1.revenue__c + pr2.revenue__c;
	
		return result;
	}
}