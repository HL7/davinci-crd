Guidance and conformance expectations around privacy and security are provided by all three specifications this implementation guide relies on. 

§§sec-1^crd-client,crd-server^exchange:Implementers **SHALL** adhere to inherited security and privacy rules^

Implementers **SHALL** adhere to any security and privacy rules defined by:

* FHIR Core: [Security & Privacy Module]({{site.data.fhir.path}}secpriv-module.html), [Security Principles]({{site.data.fhir.path}}security.html) and [Implementer's Checklist]({{site.data.fhir.path}}safety.html)
* HRex: [Privacy & Security]({{site.data.fhir.ver.hrex}}/security.html)
* CDS Hooks: [Security & Safety]({{site.data.fhir.ver.cdshooks}}/index.html#security-and-safety)
* SMART on FHIR: [SMART App Launch](http://www.hl7.org/fhir/smart-app-launch)

§§

In addition to these, this implementation guide imposes the following additional rules:

* §sec-2^crd-client,crd-server^exchange:As per the CDS Hooks specification, communications between CRD clients and CRD servers **SHALL** use TLS.§ Mutual TLS is not required by this specification but is permitted. §sec-3^crd-client,crd-server^exchange:CRD servers and CRD clients **SHOULD** enforce a minimum version and other TLS configuration requirements based on HRex rules for PHI exchange.§
    * This specification does not provide guidance on certificate management between systems, though it has been proposed that [Direct](https://directtrust.org/what-we-do/direct-secure-messaging) certificates could be used for this purpose.
* <span class="modified-content" markdown="1"><a name="FHIR-51715"> </a>§sec-4?^crd-client^exchange:CRD clients that support the Launch SMART Application Response Type **SHALL** support running applications that adhere to the SMART on FHIR confidential app profile.§</span>
* §sec-5^crd-server^processing:CRD servers **SHALL** use information received solely for coverage determination and decision support purposes.§  §sec-6^crd-server^storage:Servers **SHALL NOT** retain data received over the CRD interfaces for any purpose other than audit or providing context for form completion using DTR.§
* CRD clients are the final arbiters of what data can or cannot be shared with CRD servers.  It is up to clients to ensure they support their obligations as health data custodians, including legal, policy, and patient consent-based restrictions. Withholding information might limit the completeness or accuracy of coverage requirements discovery advice retrieved using the interfaces within this guide. The inability of a CRD server to provide full advice does not relieve providers of their responsibility to ensure that payer coverage requirements are met.
* §sec-7^crd-client^processing:CRD clients **SHALL** ensure that the resource identifiers exposed over the CRD interface are distinct from and have no determinable relationship with any business identifiers associated with those records.§ For example, the Patient.id element cannot be the same as or contain in some fashion a patient's social security number or medical record number.
* Access to patient information to meet decision support requirements is subject to regulations such as HIPAA "minimum necessary" and §sec-8^crd-client-org^business:CRD client organizations **SHOULD** audit access to check for reasonableness and appropriateness.§

<div class="fhir-conformance new-content" markdown="1" id="sec-9^crd-client-org^processing" summary="Access tokens provided as part of CRD calls **SHOULD NOT** be forwarded to systems that are not managed by the same organization or have business associate agreements that allow centralized audit of access.">
* <a name="FHIR-49757"> </a>Access tokens provided as part of CRD calls **SHOULD NOT** be forwarded to systems that are not managed by the same organization or have business associate agreements that allow centralized audit of access.  Possible alternatives to token-sharing include:
  * Routing all requests for information through the initial endpoint system
  * Making use of RFC 8693 to allow the creation of 'delegate' tokens for downstream systems"

<blockquote class="dragon" markdown="1">
Additional testing and standardization work needs to happen around making delegated access function well, particularly in a time-constrained environment.
</blockquote>
</div>
