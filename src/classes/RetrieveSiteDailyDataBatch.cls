/**
	©MadronaSG 
	
	Batch class that will retrieve first a list of all the SiteIds from SFDC.
	For each site a HTTPRequest will be made to the APPIA API to retrieve yesterday's Performance Data. The request will have a retry mechanism in case of fail.
	
	09.July.2013/Adrian: 	created the class
*/

global class RetrieveSiteDailyDataBatch implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts {
	
	global String errors;//we use Database.Stateful so we can preserve the errors from one call to another - for all the execute() method calls
	global DateTime startTime;
	global DateTime endTime;
	global Integer totalNoOfRetrievedPublisherPerformanceRecords;
	global Integer totalNoOfInsertedPublisherPerformanceRecords;

	public static String BATCH_QUERY = 'SELECT Id, Site_Id__c FROM Site__c WHERE Site_Id__c!=null';
	public static String USER_ID = '177'; //these are the credentials for the APPIA API calls
	public static String PASSWORD = 'p0cketge8r';
	
	
	global Database.QueryLocator start( Database.BatchableContext BC) {
		errors = '';
		startTime = DateTime.now();
		totalNoOfRetrievedPublisherPerformanceRecords = 0;
		totalNoOfInsertedPublisherPerformanceRecords = 0;

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
				Integer noInsertedReports = 0;
				Integer noFoundReports = 0;
				System.debug('inside execute, prList: ' + prList);
				if (!prList.isEmpty()) {
					Map<String, Publisher_Performance__c> platformToReportDataMap = new Map<String, Publisher_Performance__c>();

					for (Publisher_Performance__c pr: prList) {
						pr.Publisher__c = site.Id;
						if ((pr.platform__c == null) || (pr.platform__c == '')) pr.platform__c = 'no platform';
						if (platformToReportDataMap.get(pr.platform__c) == null) {
							//create new map entry
							platformToReportDataMap.put(pr.platform__c, pr);
						} else {
							platformToReportDataMap.put(pr.platform__c, AppiaApiIntegration.add(platformToReportDataMap.get(pr.platform__c), pr));
						}
					}

					List<Publisher_Performance__c> platformList = platformToReportDataMap.values();
					noFoundReports = platformList.size();

					totalNoOfRetrievedPublisherPerformanceRecords += platformList.size();
					System.debug('platformList has this value: ' + platformList);
					//insert platformList;
					Database.SaveResult[] srList = Database.insert(platformList, false);//allow partial success
					for (Database.SaveResult sr: srList) {
						if (sr.isSuccess()) {
							noInsertedReports += 1;
						}
					}
					totalNoOfInsertedPublisherPerformanceRecords += noInsertedReports;
				}

				errors += 'Site #' + site.Site_Id__c + ': ' + noInsertedReports + ' Publisher Performance records have been created (out of ' + noFoundReports + ' retrieved) \n';

			} catch(Exception ex) {
				errors += 'Site #' + site.Site_Id__c +': exception while processing the XML reponse string: ' + ex.getMessage() + ' \n';
			}
		} else {
			errors += 'Site #' + site.Site_Id__c +': empty response string from the APPIA API'  + ' \n';
		}
	}

	global void finish( Database.BatchableContext context ) {
		endTime = DateTime.now();

		AsyncApexJob job = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email
							FROM AsyncApexJob
							WHERE Id =:context.getJobId()];

		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		//mail.setToAddresses(new String[] { job.CreatedBy.Email } );
		mail.setToAddresses(new String[] {'adrian@eloquentix.com', 'debm@madronasg.com'});//	
		mail.setSubject('Nightly APPIA Report Data Update ' + job.Status);


		String emailBody = 'Batch Start Time: ' + startTime + '.\n';
		emailBody += 'Batch End Time: ' + endTime + '.\n';
		emailBody += 'Retrieved Publisher Performance records: ' + totalNoOfRetrievedPublisherPerformanceRecords + '.\n';
		emailBody += 'Inserted Publisher Performance records: ' + totalNoOfInsertedPublisherPerformanceRecords + '.\n';
		emailBody += 'Total number of Sites processed: ' + job.TotalJobItems + ' batches with '+ job.NumberOfErrors + ' failures.';
		if (errors != '') {
			emailBody += '\n\n\nThe following errors occured:\n'+ errors;
		}

		mail.setPlainTextBody( emailBody );
		Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
	}

}