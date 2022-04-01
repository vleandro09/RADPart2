trigger LeadTrigger on Lead (after insert, after update) {
    if(Trigger.isAfter) {
        if(Trigger.isInsert) {
            LeadTriggerHandler.handleAfterInsert(Trigger.New);
        } else if(Trigger.isUpdate) {
            LeadTriggerHandler.handleAfterUpdate(Trigger.newMap, Trigger.oldMap);
        }
    }
}