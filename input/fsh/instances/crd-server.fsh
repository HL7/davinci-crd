Instance: crd-server
InstanceOf: CapabilityStatement
Title: "CRD Server USCDI 1, 3, 4"
Usage: #definition
* url = "http://hl7.org/fhir/us/davinci-crd/CapabilityStatement/crd-server"
* name = "CRDServer"
* status = #active
* experimental = false
* date = "2022-11-25"
* description = "This statement defines the expected capabilities of systems wishing to conform to the ''CRD Server'' role.  This role is responsible for responding to CDS Hooks calls and responding with appropriate decision support.  Much of its interactions will be with payer back-end systems over non-FHIR protocols.  This CapabilityStatement does not describe these 'server <-> payer' interactions.  Instead, it focuses on the ability of the CRD server to interact with the CRD client's FHIR endpoint to retrieve additional data.  All such interactions are optional, as their necessity is dependent on what types of information is needed to support payer rules, the types of coverage the payer offers, and the degree of sophistication of the decision support offered by the CRD server.  All resources and search parameters supported by US Core are fair game, though the [3.1.1](CapabilityStatement-crd-client3.1.html), [6.1.0](CapabilityStatement-crd-client6.1.html), and [7.0.0](CapabilityStatement-crd-client7.0.html) clients might vary in which resources, search parameters, and search parameter combinations they support.  CRD servers will need to access the CapabilityStatement of the server they are communicating with to determine what search and read capabilities are available."
* kind = #requirements
* fhirVersion = #4.0.1
* format = #json
* rest
  * mode = #client
  * documentation = "A CRD server acts as a client, soliciting patient information from the FHIR endpoint of the CRD client, retrieving additional information needed to provide decision support."
  * security.description = "Implementations **SHALL** meet the general security requirements documented in the [HRex implementation guide](http://hl7.org/fhir/us/davinci-hrex/STU1.2.0/security.html)."
