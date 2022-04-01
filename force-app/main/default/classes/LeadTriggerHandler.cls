public with sharing class LeadTriggerHandler {
    public static void handleAfterInsert(List<Lead> newLeads) {
        // Create a new list to hold newly created tasks
        List<Task> newTasks = new List<Task>();

        // For each lead passed from our trigger
        for(Lead lead : newLeads) {
           // If ProductInterst contains a value, create the appropriate task
           if(lead.ProductInterest__c != null) {
               // For the record, I struggled with this since in our Trailhead, WhatId was used to create a Task.  Apparently Lead uses WhoId.
               newTasks.add(new Task(WhoId = lead.Id, Subject = 'Follow Up: ' + lead.ProductInterest__c));
            }
        }
		// Check to see if the newTasks list has records then insert those records
        if(newTasks.size() > 0) {
         	insert newTasks;   
        }
    }
    
    public static void handleAfterUpdate(Map<Id, Lead> newMap, Map<Id, Lead> oldMap) {
        // Create a new list to hold newly created tasks
        List<Task> newTasks = new List<Task>();
        
        // For each lead check to see if the value of ProductInterest changed.  If the value has changed and the field is not null create task
        for(Lead lead : newMap.values()) {
            if(oldMap.get(lead.Id).ProductInterest__c != newMap.get(lead.Id).ProductInterest__c){
                if(lead.ProductInterest__c != null) {
	                // For the record, I struggled with this since in our Trailhead, WhatId was used to create a Task.  Apparently Lead uses WhoId.
                    newTasks.add(new Task(WhoId = lead.Id, Subject = 'Follow Up: ' + lead.ProductInterest__c));
                }
            } 
        }
        // Check to see if the newTasks list has records then insert those records
        if(newTasks.size() > 0) {
            insert newTasks;
        }
    }
}
