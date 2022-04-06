trigger RecipeTrigger on Recipe__c (before insert, before update, after insert, after update) {

        // Instantiate the Trigger Handler and set Trigger records
        RecipeTriggerHandler handler = new RecipeTriggerHandler(Trigger.new, Trigger.oldMap);

        if(Trigger.isBefore) {
            if(Trigger.isInsert) {
                handler.handleBeforeInsertUpdate();
            } else if(Trigger.isUpdate) {
                handler.handleBeforeInsertUpdate();
            }
        } else if (Trigger.isAfter) {
            if(Trigger.isInsert) {
                handler.handleAfterIsertUpdate();
            } else if (Trigger.isUpdate) {
                handler.handleAfterIsertUpdate();
            }
        }

}