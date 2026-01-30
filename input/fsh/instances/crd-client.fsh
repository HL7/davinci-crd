Instance: crd-client3.1
InstanceOf: CapabilityStatement
Title: "CRD Client USCDI 1"
Usage: #definition
* url = "http://hl7.org/fhir/us/davinci-crd/CapabilityStatement/crd-client3.1"
* name = "CRDClient3_1"
* description = "This statement defines the expected capabilities of systems wishing to conform to the ''CRD Client'' role for USCDI 1 (US Core 3.1.1).  This role is responsible for initiating CDS Hooks calls and consuming received decision support.  It is *also* responsible for returning the data requested by the CRD Server needed to provide that decision support.  This capability statement does  define the CDS Hooks capabilities as there is no standard way to do that yet.  Instead, it focuses on the 'server' capabilities needed to respond to CRD Server queries.  These capabilities are based on US Core."
* imports = "http://hl7.org/fhir/us/core/CapabilityStatement/us-core-server|3.1.1"
* insert CommonClient

Instance: crd-client6.1
InstanceOf: CapabilityStatement
Title: "CRD Client USCDI 3"
Usage: #definition
* url = "http://hl7.org/fhir/us/davinci-crd/CapabilityStatement/crd-client6.1"
* name = "CRDClient6_1"
* description = "This statement defines the expected capabilities of systems wishing to conform to the ''CRD Client'' role for USCDI 3 (US-Core 6.1.0).  This role is responsible for initiating CDS Hooks calls and consuming received decision support.  It is *also* responsible for returning the data requested by the CRD Server needed to provide that decision support.  This capability statement does not define the CDS Hooks capabilities as there is no standard way to do that yet.  Instead, it focuses on the 'server' capabilities needed to respond to CRD Server queries.  These capabilities are based on US Core."
* imports = "http://hl7.org/fhir/us/core/CapabilityStatement/us-core-server|6.1.0"
* insert CommonClient

Instance: crd-client7.0
InstanceOf: CapabilityStatement
Title: "CRD Client USCDI 4"
Usage: #definition
* url = "http://hl7.org/fhir/us/davinci-crd/CapabilityStatement/crd-client7.0"
* name = "CRDClient7_0"
* description = "This statement defines the expected capabilities of systems wishing to conform to the ''CRD Client'' role for USCDI 4 (US-Core 7.9.0).  This role is responsible for initiating CDS Hooks calls and consuming received decision support.  It is *also* responsible for returning the data requested by the CRD Server needed to provide that decision support.  This capability statement does not define the CDS Hooks capabilities as there is no standard way to do that yet.  Instead, it focuses on the 'server' capabilities needed to respond to CRD Server queries.  These capabilities are based on US Core."
* imports = "http://hl7.org/fhir/us/core/CapabilityStatement/us-core-server|7.0.0"
* insert CommonClient

RuleSet: CommonClient
* fhirVersion = #4.0.1
* status = #active
* experimental = false
* date = "2022-11-25"
* kind = #requirements
* format = #json
* rest
  * mode = #server
  * documentation = "A CRD Client provides a FHIR server endpoint, returning patient information to the CRD server, ensuring it has the needed information to perform decision support."
  * security.description = "Implementations **SHALL** meet the general security requirements documented in the [[http://hl7.org/fhir/us/davinci-hrex/STU1.2.0-snapshot/security.html|HRex implementation guide]]."
  * insert CSresourceCRD(#Appointment, profile-appointment-with-order)
    * resource[=].supportedProfile[+] = "http://hl7.org/fhir/us/davinci-crd/StructureDefinition/profile-appointment-no-order"
    * resource[=].versioning = #versioned-update
    * insert CSinteraction(#MAY, #update, [[Allows annotating the appointment in response to a card.  (CRD Clients **SHALL** support update requests received via supported system actions, but it is acceptable if clients opt to perform such updates via a mechanism other than their FHIR API.)]])
  * insert CSresourceCRD(#CommunicationRequest, profile-communicationrequest)
    * resource[=].versioning = #versioned-update
    * insert CSinteraction(#MAY, #update, [[Allows annotating the communication request in response to a card.  (CRD Clients **SHALL** support update requests received via supported system actions, but it is acceptable if clients opt to perform such updates via a mechanism other than their FHIR API.)]])
  * insert CSresourceCRD(#DeviceRequest, profile-devicerequest)
    * resource[=].versioning = #versioned-update
    * insert CSinteraction(#MAY, #update, [[Allows annotating the device request in response to a card.  (CRD Clients **SHALL** support update requests received via supported system actions, but it is acceptable if clients opt to perform such updates via a mechanism other than their FHIR API.)]])
  * insert CSresourceCRD(#Encounter, profile-encounter)
    * insert CSinteraction(#MAY, #update, [[Allows annotating the encounter in response to a card.  (CRD Clients **SHALL** support update requests received via supported system actions, but it is acceptable if clients opt to perform such updates via a mechanism other than their FHIR API.]])
    * insert CSinteraction(#SHOULD, #search-type, [[Allows retrieval of the encounter for a nutrition order (including referenced location) if not retrieved as part of pre-fetch.  (Support is mandatory if not supported as part of pre-fetch.)]])
    * resource[=].versioning = #versioned-update
  * insert CSresourceCRD(#MedicationRequest, profile-medicationrequest)
    * resource[=].versioning = #versioned-update
    * insert CSinteraction(#MAY, #update, [[Allows annotating the medication request in response to a card.  (CRD Clients **SHALL** support update requests received via supported system actions, but it is acceptable if clients opt to perform such updates via a mechanism other than their FHIR API.)]])
  * insert CSresourceCRD(#NutritionOrder, profile-nutritionorder)
    * resource[=].versioning = #versioned-update
    * insert CSinteraction(#MAY, #update, [[Allows annotating the nutrition order in response to a card.  (CRD Clients **SHALL** support update requests received via supported system actions, but it is acceptable if clients opt to perform such updates via a mechanism other than their FHIR API.)]])
  * insert CSresourceCRD(#ServiceRequest, profile-servicerequest)
    * resource[=].versioning = #versioned-update
    * insert CSinteraction(#MAY, #update, [[Allows annotating the service requests in response to a card.  (CRD Clients **SHALL** support update requests received via supported system actions, but it is acceptable if clients opt to perform such updates via a mechanism other than their FHIR API.)]])
  * insert CSresourceCRD(#VisionPrescription, profile-visionprescription)
    * resource[=].versioning = #versioned-update
    * insert CSinteraction(#MAY, #update, [[Allows annotating the vision prescription in response to a card.  (CRD Clients **SHALL** support update requests received via supported system actions, but it is acceptable if clients opt to perform such updates via a mechanism other than their FHIR API.)]])
  * insert CSresourceCRD(#Coverage, profile-coverage)
    * insert CSinteraction(#SHOULD, #search-type, [[Allows retrieval of the patient's coverage information if it is not retrieved as part of pre-fetch.  (Support is mandatory if not supported as part of pre-fetch.)  Note that only coverages relevant to the payer(s) associated with the requesting CRD Server are allowed to be returned.]])
  * insert CSresourceCRD(#Device, profile-device)
    * insert CSinteraction(#SHOULD, #read, [[Allows retrieval of the device requested in a DeviceRequest if it is not retrieved as part of pre-fetch.  (Support is mandatory if not supported as part of pre-fetch.)]])
  * insert CSresourceCRD(#Location, profile-location)
    * insert CSinteraction(#SHOULD, #read, [[Allows retrieval of the location associated with an order or appointment if not retrieved as part of pre-fetch.  (Support is mandatory if not supported as part of pre-fetch.)]])
  * insert CSresourceCRD(#Organization, profile-organization)
    * insert CSinteraction(#SHOULD, #read, [[Allows retrieval of ordering and/or performing organization's information if not retrieved as part of pre-fetch.  (Support is mandatory if not supported as part of pre-fetch.)]])
  * insert CSresourceCRD(#Patient, profile-patient)
    * insert CSinteraction(#SHOULD, #read, [[Allows retrieval of the patient demographics if patient is not retrieved as part of pre-fetch.  (Support is mandatory if not supported as part of pre-fetch.)]])
  * insert CSresource(#Practitioner, "http://hl7.org/fhir/us/core/StructureDefinition/us-core-practitioner")
    * insert CSinteraction(#SHOULD, #read, [[Allows retrieval of ordering and/or performing provider's information if not retrieved as part of pre-fetch.  (Support is mandatory if not supported as part of pre-fetch.)]])
  * insert CSresource(#PractitionerRole, "http://hl7.org/fhir/us/davinci-hrex/StructureDefinition/hrex-practitionerrole")
    * insert CSinteraction(#SHOULD, #search-type, [[Allows retrieval of ordering and/or performing provider's (including associated Practitioners and Organizations) if not retrieved as part of pre-fetch.  (Support is mandatory if not supported as part of pre-fetch.)]])
