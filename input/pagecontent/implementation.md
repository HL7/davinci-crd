<div markdown="1" class="new-content">

This page lists considerations and recommendations for implementation that fall outside the conformance expectations established by the specification.  I.e. It covers content that the specification authors and project team consider to be essential business practices, good ideas, as well as concepts worthy of consideration/awareness.  However, the content here doesn't define specific testable behavior.

### Suppressing Guidance

Some CRD clients might suppress certain types of payer guidance as being the 'default' presumption.  E.g. "Covered, no prior authorization required".  Where CRD systems do this, there may be an issue if the CRD service becomes unable to respond and the CRD client does not clearly flag to the user that the service is not available.  I.e. Providers may incorrectly presume that authorization is not needed.  Clients that perform such suppression of messages **SHALL** mitigate this potential for misinterpretation.

### Limitations on Accuracy

In rare situations, circumstances may change in a way that invalidates information provided by a CRD server prior to execution of an ordered service.  E.g. coverage is terminated or changed by the employer, data in the record is subsequently found to be erroneous, etc.  Providers (and where provided information is shared with them, patients) will need to be aware that, irrespective of this guide's expectations for [accuracy](foundation.html#accuracy), assertions made by a CRD Server are always "point-in-time" and do not constitute an irrevocable promise any more than equivalent assertions made in the paper/fax/phone-call world.

### Managing 

Key aspects of interoperability for this specification include agreement on how to identify payers, identify different types of coverage, etc.  As yet, there is no industry wide solution to this issue.  However, HL7 is working with industry partners on viable solutions to these issues.  Guidance and recommendations on how to manage consistent identity of payer concepts as well as other topics can be found in the [CRD Implementer Support](https://confluence.hl7.org/pages/viewpage.action?pageId=91991946) confluence page.  Some of the guidance there may migrate to this specification and become 'SHALL' in future releases, so implementers are strongly encouraged to align with the guidance on the page in their early development.

</div>