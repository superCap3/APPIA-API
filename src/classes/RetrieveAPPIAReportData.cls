/**
	©MadronaSG 
	
	Scheduler class for the RetrieveSiteDailyDataBatch.cls
	This class is used to start the nigthly job of retrieving yesterday's report data for all SFDC Sites from the APPIA API

	09.July.2013/Adrian: 	created the class
*/

global class RetrieveAPPIAReportData implements Schedulable {

	public Integer BATCH_SIZE = 1;

	global void execute(SchedulableContext sc) {
		RetrieveSiteDailyDataBatch r = new RetrieveSiteDailyDataBatch();
		database.executebatch(r, BATCH_SIZE); 
	}
}