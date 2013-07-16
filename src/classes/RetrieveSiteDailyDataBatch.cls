/**
	©MadronaSG 
	
	Batch class that will retrieve first a list of all the SiteIds from SFDC.
	For each site a HTTPRequest will be made to the APPIA API to retrieve yesterday's Performance Data. The request will have a retry mechanism in case of fail.
	
	09.July.2013/Adrian: 	created the class
*/

global class RetrieveSiteDailyDataBatch implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts {
	
	global String errors;//we use Database.Stateful so we can preserve the errors from one call to another - for all the execute() method calls
	public static String BATCH_QUERY = 'SELECT Id, Site_Id__c FROM Site__c WHERE Site_Id__c!=null';
	public static String USER_ID = '177'; //these are the credentials for the APPIA API calls
	public static String PASSWORD = 'p0cketge8r';
	
	
	global Database.QueryLocator start( Database.BatchableContext BC) {
		return Database.getQueryLocator(BATCH_QUERY);
	} 

	// Batch execution
	global void execute(Database.BatchableContext BC, List<Site__c> sites) {
		//we get the Site__c, the only element if the sites list
		Site__c site = sites[0]; 

		String effectiveUrl = 'http://reports.appia.com/api/country_report?id=' + USER_ID + '&password=' + PASSWORD + '&siteId=' + site.Site_Id__c;
		RestClient rc = new RestClient();
		
		String results = rc.get(effectiveUrl);

		if ((results != null) && (results != '')) {
			try {
				//we get the list of campaigns(Publisher_Performance data)
				List<Publisher_Performance__c> prList = AppiaApiIntegration.getReportsList(results);
				if (!prList.isEmpty()) {
					for (Publisher_Performance__c pr: prList) {
						pr.Publisher__c = site.Id;
					}

					insert prList;
				}

				errors += 'Site #' + site.Site_Id__c + ': ' + prList.size() + ' Publisher Performance records have been created' + ' \n';

			} catch(Exception ex) {
				errors += 'Site #' + site.Site_Id__c +': exception while processing the XML reponse string: ' + ex.getMessage() + ' \n';
			}
		} else {
			errors += 'Site #' + site.Site_Id__c +': empty response string from the APPIA API'  + ' \n';
		}
	}

	global void finish( Database.BatchableContext context ) {
		AsyncApexJob job = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email
							FROM AsyncApexJob
							WHERE Id =:context.getJobId()];

		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		//mail.setToAddresses(new String[] { job.CreatedBy.Email } );
		mail.setToAddresses(new String[] {'adrian@eloquentix.com', 'debm@madronasg.com'});
		mail.setSubject('Nightly APPIA Report Data Update ' + job.Status);

		String emailBody = 'Total number of SFDC Sites ' + job.TotalJobItems + ' batches with '+ job.NumberOfErrors + ' failures.';
		if (errors != '') {
			emailBody += '\n\n\nThe following errors occured:\n'+ errors;
		}

		mail.setPlainTextBody( emailBody );
		Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
	}

}