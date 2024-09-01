<!--- Text entered into this file will appear at the top of the profiles page before the Formal Views of the profile content. -->

<div class="new-content" markdown="1">
### doc-needed vs. info-needed
This extension has two properties with similar names which may cause some confusion.  Each has a very distinct purpose.

'doc-needed' is used to indicate the need for additional information to be collected (typically via DTR questionnaires) in order for the payer to make decisions about coverage and prior authorization.  It indicates the type of user who will need to provide the answers.  Once those answers are provided, a decision about coverage and at least whether prior authorization is necessary should be possible.

'info-needed' is used when the information provided in the hook payload isn't even sufficient to determine what questions might be asked.  For example, it may be necessary to know the performer, the location, have a better sense on the timeframe for service delivery, etc.  In this case, the payer is indicating that a 'useful' response will need to wait until the relevant information is available.  This might be a later hook in the same system (e.g. an ''order-dispatch'' or ''appointment-book'' if needing to know the performer or location), or might mean that a decision won't be able to be made until the patient hits the ''encounter-start'' hook in the performing system.  The extension element indicates the nature of the information needed, which should give the provider an idea of where in the workflow a decision is likely.
</div>