Guidance and conformance expectations around privacy and security are provided by all three specifications this implementation guide relies on.  Implementers **SHALL** adhere to any security and privacy rules defined by:

* FHIR Core: [Security & Privacy Module]({{site.data.fhir.path}}secpriv-module.html), [Security Principles]({{site.data.fhir.path}}security.html) and [Implementer's Checklist]({{site.data.fhir.path}}safety.html)
* HRex: [Privacy & Security]({{site.data.fhir.ver.hrex}}/security.html)
* CDS Hooks: [Security & Safety](https://cds-hooks.hl7.org/2.0/#security-and-safety)
* SMART on FHIR: [SMART App Launch](http://www.hl7.org/fhir/smart-app-launch)

In addition to these, this implementation guide imposes the following additional rules:

* As per the CDS Hook specification, communications between CRD Clients and CRD Servers **SHALL** use TLS.  Mutual TLS is not required by this specification but is permitted.  CRD Servers and CRD Clients **SHOULD** enforce a minimum version and other TLS configuration requirements based on HRex rules for PHI exchange.
    * This specification does not provide guidance on certificate management between systems, though it has been proposed that Direct certificates could be used for this purpose.
* CRD Clients **SHALL** support running applications that adhere to the SMART on FHIR [confidential app](http://www.hl7.org/fhir/smart-app-launch#support-for-public-and-confidential-apps) profile.
* CRD Servers **SHALL** use information received solely for coverage determination and decision support purposes and **SHALL NOT** retain data received over the CRD interfaces for any purpose other than audit or providing context for form completion using DTR.
* CRD Clients are the final arbiters of what data can or cannot be shared with CRD Servers and **SHOULD** filter or withhold any resources or data elements necessary to support their obligations as health data custodians, including legal, policy, and patient consent-based restrictions.  Withholding information might, however, limit the completeness or accuracy of coverage requirements discovery advice retrieved using the interfaces within this guide.  The inability of a CRD Server to provide full advice does not relieve providers of their responsibility for ensuring that payer coverage requirements are met.
* CRD Clients **SHALL** ensure that the resource identifiers exposed over the CRD interface are distinct from and have no determinable relationship with any business identifiers associated with those records.  E.g., the Patient.id element cannot be the same as or contain in some fashion a patient's social security number or medical record number.
* Access to patient information to meet decision support requirements is still subject to regulations such as HIPAA "minimum necessary" and CRD clients **SHOULD** audit access to check for reasonableness and appropriateness.

### Sharing Information with Payers

All information sharing that occurs through making CRD calls is subject to the privacy and security considerations documented [here]({{site.data.fhir.ver.hrex}}/security.html).
