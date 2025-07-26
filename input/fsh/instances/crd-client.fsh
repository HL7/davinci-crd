Instance: crd-client3.1
InstanceOf: CapabilityStatement
Title: "CRD Client USCDI 1"
Usage: #definition
* url = "http://hl7.org/fhir/us/davinci-crd/CapabilityStatement/crd-client3.1"
* name = "CRDClient3_1"
* description = "This statement defines the expected capabilities of systems wishing to conform to the ''CRD Client'' role for USCDI 1 (US Core 3.1.1).  This role is responsible for initiating CDS Hooks calls and consuming received decision support.  It is *also* responsible for returning the data requested by the CRD Server needed to provide that decision support.  This capability statement doesn't define the CDS Hooks capabilities as there is no standard way to do that yet.  Instead, it focuses on the 'server' capabilities needed to respond to CRD Server queries.  These capabilities are based on US Core.\n\nIn addition to the U.S. core expectations, the CRD Client **SHALL** support all 'SHOULD' 'read' and 'search' capabilities listed below for resources referenced in supported hooks and order types if it does not support returning the associated resources as part of CDS Hooks pre-fetch.  The CRD Client **SHALL** also support 'update' functionality for all resources listed below where the client allows invoking hooks based on the resource."
* imports = "http://hl7.org/fhir/us/core/CapabilityStatement/us-core-server|3.1.1"
* insert CommonClient

Instance: crd-client6.1
InstanceOf: CapabilityStatement
Title: "CRD Client USCDI 3"
Usage: #definition
* url = "http://hl7.org/fhir/us/davinci-crd/CapabilityStatement/crd-client6.1"
* name = "CRDClient6_1"
* description = "This statement defines the expected capabilities of systems wishing to conform to the ''CRD Client'' role for USCDI 3 (US-Core 6.1.0).  This role is responsible for initiating CDS Hooks calls and consuming received decision support.  It is *also* responsible for returning the data requested by the CRD Server needed to provide that decision support.  This capability statement doesn't define the CDS Hooks capabilities as there is no standard way to do that yet.  Instead, it focuses on the 'server' capabilities needed to respond to CRD Server queries.  These capabilities are based on US Core.\n\nIn addition to the U.S. core expectations, the CRD Client **SHALL** support all 'SHOULD' 'read' and 'search' capabilities listed below for resources referenced in supported hooks and order types if it does not support returning the associated resources as part of CDS Hooks pre-fetch.  The CRD Client **SHALL** also support 'update' functionality for all resources listed below where the client allows invoking hooks based on the resource."
* imports = "http://hl7.org/fhir/us/core/CapabilityStatement/us-core-server|6.1.0"
* insert CommonClient

Instance: crd-client7.0
InstanceOf: CapabilityStatement
Title: "CRD Client USCDI 4"
Usage: #definition
* url = "http://hl7.org/fhir/us/davinci-crd/CapabilityStatement/crd-client7.0"
* name = "CRDClient7_0"
* description = "This statement defines the expected capabilities of systems wishing to conform to the ''CRD Client'' role for USCDI 4 (US-Core 7.9.0).  This role is responsible for initiating CDS Hooks calls and consuming received decision support.  It is *also* responsible for returning the data requested by the CRD Server needed to provide that decision support.  This capability statement doesn't define the CDS Hooks capabilities as there is no standard way to do that yet.  Instead, it focuses on the 'server' capabilities needed to respond to CRD Server queries.  These capabilities are based on US Core.\n\nIn addition to the U.S. core expectations, the CRD Client **SHALL** support all 'SHOULD' 'read' and 'search' capabilities listed below for resources referenced in supported hooks and order types if it does not support returning the associated resources as part of CDS Hooks pre-fetch.  The CRD Client **SHALL** also support 'update' functionality for all resources listed below where the client allows invoking hooks based on the resource."
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
  * security.description = "Implementations **SHALL** meet the general security requirements documented in the [[http://hl7.org/fhir/us/davinci-hrex/STU1/security.html|HRex implementation guide]]."
  * insert CSresourceCRD(#Appointment, profile-appointment-with-order)
    * resource[=].supportedProfile[+] = "http://hl7.org/fhir/us/davinci-crd/StructureDefinition/profile-appointment-no-order"
    * resource[=].versioning = #versioned-update
    * insert CSinteraction(#SHOULD, #update, [[Allows annotating the appointment in response to a card.  (Support is mandatory if the system supports Appointments)]])
  * insert CSresourceCRD(#CommunicationRequest, profile-communicationrequest)
    * resource[=].versioning = #versioned-update
    * insert CSinteraction(#SHOULD, #update, [[Allows annotating the communication request in response to a card.  (Support is mandatory if the system supports CommunicationRequests)]])
  * insert CSresourceCRD(#DeviceRequest, profile-devicerequest)
    * resource[=].versioning = #versioned-update
    * insert CSinteraction(#SHOULD, #update, [[Allows annotating the device request in response to a card.  (Support is mandatory if the system supports DeviceRequests.)]])
  * insert CSresourceCRD(#Encounter, profile-encounter)
    * insert CSinteraction(#SHOULD, #update, [[Allows annotating the encounter in response to a card.  (Support is mandatory if the system supports Encounters)]])
    * insert CSinteraction(#SHOULD, #search-type, [[Allows retrieval of the encounter for a nutrition order (including referenced location) if not retrieved as part of pre-fetch.  (Support is mandatory if not supported as part of pre-fetch.)]])
    * resource[=].versioning = #versioned-update
    * resource[=].searchInclude = "Encounter:location"
    * insert CSsearch(#SHALL, "patient", "http://hl7.org/fhir/SearchParameter/Coverage-patient", #reference, [[Allows filtering encounters based on the patient focus of the encounter]])
    * insert CSsearch(#SHALL, "_id", "http://hl7.org/fhir/SearchParameter/Resource-id", #token, [[Allows searching for a Encounter by id]])
    * insert CSsearch(#SHALL, "organization", "http://hl7.org/fhir/SearchParameter/Encounter-location", #reference, [[Allows performing an _include on Location when retrieving an Encounter]])
  * insert CSresourceCRD(#MedicationRequest, profile-medicationrequest)
    * resource[=].versioning = #versioned-update
    * insert CSinteraction(#SHOULD, #update, [[Allows annotating the medication request in response to a card.  (Support is mandatory if the system supports MedicationRequests)]])
  * insert CSresourceCRD(#NutritionOrder, profile-nutritionorder)
    * resource[=].versioning = #versioned-update
    * insert CSinteraction(#SHOULD, #update, [[Allows annotating the nutrition order in response to a card.  (Support is mandatory if the system supports NutritionOrders.)]])
  * insert CSresourceCRD(#ServiceRequest, profile-servicerequest)
    * resource[=].versioning = #versioned-update
    * insert CSinteraction(#SHOULD, #update, [[Allows annotating the service requests in response to a card.  (Support is mandatory if the system supports ServiceRequests.)]])
  * insert CSresourceCRD(#VisionPrescription, profile-visionprescription)
    * resource[=].versioning = #versioned-update
    * insert CSinteraction(#SHOULD, #update, [[Allows annotating the vision prescription in response to a card.  (Support is mandatory if the system supports VisionPrescriptions)]])
  * insert CSresourceCRD(#Coverage, profile-coverage)
    * insert CSinteraction(#SHOULD, #search-type, [[Allows retrieval of the patient's coverage information if it is not retrieved as part of pre-fetch.  (Support is mandatory if not supported as part of pre-fetch.)  Note that only coverages relevant to the payer(s) associated with the requesting CRD Server are allowed to be returned.]])
    * insert CSsearch(#SHALL, "patient", "http://hl7.org/fhir/SearchParameter/Coverage-patient", #reference, [[Allows retrieving coverages for the patient]])
    * insert CSsearch(#SHALL, "status", "http://hl7.org/fhir/SearchParameter/Coverage-status", #token, [[Allows filtering to only active coverages]])
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
    * resource[=].searchInclude[+] = "PractitionerRole:organization"
    * resource[=].searchInclude[+] = "PractitionerRole:practitioner"
    * insert CSsearch(#SHALL, "_id", "http://hl7.org/fhir/SearchParameter/Resource-id", #token, [[Allows searching for a PractitionerRole by id]])
    * insert CSsearch(#SHALL, "organization", "http://hl7.org/fhir/SearchParameter/PractitionerRole-organization", #reference, [[Allows performing an _include on Organization when retrieving a PractitionerRole]])
    * insert CSsearch(#SHALL, "practitioner", "http://hl7.org/fhir/SearchParameter/PractitionerRole-practitioner", #reference, [[Allows performing an _include on Practitioner when retrieving a PractitionerRole]])
