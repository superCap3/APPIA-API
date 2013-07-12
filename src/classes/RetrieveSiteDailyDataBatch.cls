/**
	©MadronaSG 
	
	Batch class that will retrieve first a list of all the SiteIds from SFDC.
	For each site a HTTPRequest will be made to the APPIA API to retrieve yesterday's Performance Data. The request will have a retry mechanism in case of fail.
	
	09.July.2013/Adrian: 	created the class
*/

global class RetrieveSiteDailyDataBatch implements Database.Batchable<sObject>, Database.Stateful {
	
	global String errors;
	public static String BATCH_QUERY = 'SELECT Id, Site_Id__c FROM Site__c WHERE Site_Id__c!=null';
	
	
	global Database.QueryLocator start( Database.BatchableContext BC) {
		return Database.getQueryLocator( BATCH_QUERY );
	} 

	// Batch execution
	global void execute(Database.BatchableContext BC, List<Site__c> sites) {
		//we get the Site__c, the only element if the sites list


		/*if ( !opportunities.isEmpty() )
		{
			List<Database.SaveResult> dmlResults = Database.update( opportunities , false );
			for( Database.SaveResult dmlResult : dmlResults )
			{
				if( !dmlResult.isSuccess() )
				{
					for( Database.Error err : dmlResult.getErrors() )
					{
						errors += err.getMessage() + ' \n';
					} // end for
				} // end is Success If
			}// end dml results loop
		}*/
	}

	global void finish( Database.BatchableContext context ) {
		AsyncApexJob job = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email
							FROM AsyncApexJob
							WHERE Id =:context.getJobId()];

		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		mail.setToAddresses( new String[] { job.CreatedBy.Email } );
		mail.setSubject( 'Nightly APPIA Report Data Update ' + job.Status );

		String emailBody = 'Total number of SFDC Sites ' + job.TotalJobItems + ' batches with '+ job.NumberOfErrors + ' failures.';
		if (errors != '') {
			emailBody += '\n\n\nThe following errors occured:\n'+ errors;
		}

		mail.setPlainTextBody( emailBody );
		Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
	}

}