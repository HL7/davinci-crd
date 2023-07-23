Instance: crd-server
InstanceOf: CapabilityStatement
Title: "CRD Server"
Usage: #definition
* url = "http://hl7.org/fhir/us/davinci-crd/CapabilityStatement/crd-server"
* name = "CRDServer"
* status = #active
* experimental = false
* date = "2022-11-25"
* description = "This statement defines the expected capabilities of systems wishing to conform to the ''CRD Server'' role.  This role is responsible for responding to CDS Hooks calls and responding with appropriate decision support.  Much of its interactions will be with payer back-end systems over non-FHIR protocols.  This CapabilityStatement does not describe these 'server <-> payer' interactions.  Instead, it focuses on the ability of the CRD service to interact with the CRD client's FHIR endpoint to retrieve additional data.  All such interactions are optional, as their necessity is dependent on what types of information is needed to support payer rules, the types of coverage the payer offers, and the degree of sophistication of the decision support offered by the CRD server.  All resources and search parameters supported by US Core are fair game, though [[CapabilityStatement-crd-client|client endpoints]] might vary in which resources they support."
* kind = #requirements
* imports = "http://hl7.org/fhir/us/core/CapabilityStatement/us-core-client"
* fhirVersion = #4.0.1
* format = #json
* rest
  * mode = #client
  * documentation = "A CRD server acts as a client, soliciting patient information from the FHIR endpoint of the CRD client, retrieving additional information needed to provide decision support."
  * security.description = "Implementations **SHALL** meet the general security requirements documented in the [[http://hl7.org/fhir/us/davinci-hrex/STU1/security.html|HRex implementation guide]]."