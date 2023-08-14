Instance: crd-client
InstanceOf: CapabilityStatement
Title: "CRD Client"
Usage: #definition
* url = "http://hl7.org/fhir/us/davinci-crd/CapabilityStatement/crd-client"
* name = "CRDClient"
* status = #active
* experimental = false
* date = "2022-11-25"
* description = "This statement defines the expected capabilities of systems wishing to conform to the ''CRD Client'' role.  This role is responsible for initiating CDS Hooks calls and consuming received decision support.  It is *also* responsible for returning data requested by the CRD Server needed to provide that decision support.  This capability statement doesn't define the CDS Hooks capabilities as there is no standard way to do that as yet.  Instead, it focuses on the 'server' capabilities needed to respond to CRD Server queries.  These capabilities are based on US Core.\n\nIn addition to the U.S. core expectations, the CRD Client **SHALL** support all 'SHOULD' 'read' and 'search' capabilities listed below for resources referenced in supported hooks and order types if it does not support returning the associated resources as part of CDS Hooks pre-fetch.  The CRD Client **SHALL** also support 'update' functionality for all resources listed below where the client allows invoking hooks based on the resource."
* kind = #requirements
* imports = "http://hl7.org/fhir/us/core/CapabilityStatement/us-core-server"
* fhirVersion = #4.0.1
* format = #json
* rest
  * mode = #server
  * documentation = "A CRD Client provides a FHIR server endpoint, returning patient information to the CRD server, ensuring it has the needed information to perform decision support."
  * security.description = "Implementations **SHALL** meet the general security requirements documented in the [[http://hl7.org/fhir/us/davinci-hrex/STU1/security.html|HRex implementation guide]]."
  * resource[0]
    * type = #Appointment
    * supportedProfile = "http://hl7.org/fhir/us/davinci-crd/StructureDefinition/profile-appointment"
    * interaction
      * extension
        * url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
        * valueCode = #SHOULD
      * code = #update
      * documentation = "Allows annotating the appointment in response to a card.  (Support is mandatory if the system supports Appointments)"
    * versioning = #versioned-update
  * resource[+]
    * type = #CommunicationRequest
    * supportedProfile = "http://hl7.org/fhir/us/davinci-crd/StructureDefinition/profile-communicationrequest"
    * interaction
      * extension
        * url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
        * valueCode = #SHOULD
      * code = #update
      * documentation = "Allows annotating the communication request in response to a card.  (Support is mandatory if the system supports CommunicationRequests)"
    * versioning = #versioned-update
  * resource[+]
    * type = #Coverage
    * supportedProfile = "http://hl7.org/fhir/us/davinci-crd/StructureDefinition/profile-coverage"
    * interaction
      * extension
        * url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
        * valueCode = #SHOULD
      * code = #search-type
      * documentation = "Allows retrieval of the patient's coverage information if it is not retrieved as part of pre-fetch.  (Support is mandatory if not supported as part of pre-fetch.)  Note that only coverages relevant to the payer(s) associated with the requesting CRD Server are allowed to be returned."
    * searchParam[0]
      * extension
        * url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
        * valueCode = #SHALL
      * name = "patient"
      * definition = "http://hl7.org/fhir/SearchParameter/Coverage-patient"
      * type = #reference
      * documentation = "Allows retrieving coverages for the patient"
    * searchParam[+]
      * extension
        * url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
        * valueCode = #SHALL
      * name = "status"
      * definition = "http://hl7.org/fhir/SearchParameter/Coverage-status"
      * type = #token
      * documentation = "Allows filtering to only active coverages"
  * resource[+]
    * type = #Device
    * supportedProfile = "http://hl7.org/fhir/us/davinci-crd/StructureDefinition/profile-device"
    * interaction
      * extension
        * url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
        * valueCode = #SHOULD
      * code = #read
      * documentation = "Allows retrieval of the device requested in a DeviceRequest if it is not retrieved as part of pre-fetch.  (Support is mandatory if not supported as part of pre-fetch.)"
  * resource[+]
    * type = #DeviceRequest
    * supportedProfile = "http://hl7.org/fhir/us/davinci-crd/StructureDefinition/profile-devicerequest"
    * interaction
      * extension
        * url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
        * valueCode = #SHOULD
      * code = #update
      * documentation = "Allows annotating the device request in response to a card.  (Support is mandatory if the system supports DeviceRequests.)"
    * versioning = #versioned-update
  * resource[+]
    * type = #Encounter
    * supportedProfile = "http://hl7.org/fhir/us/davinci-crd/StructureDefinition/profile-encounter"
    * interaction[0]
      * extension
        * url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
        * valueCode = #SHOULD
      * code = #update
      * documentation = "Allows annotating the encounter in response to a card.  (Support is mandatory if the system supports Encounters)"
    * interaction[+]
      * extension
        * url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
        * valueCode = #SHOULD
      * code = #search-type
      * documentation = "Allows retrieval of the encounter for a nutrition order (including referenced location) if not retrieved as part of pre-fetch.  (Support is mandatory if not supported as part of pre-fetch.)"
    * versioning = #versioned-update
    * searchInclude = "Encounter:location"
    * searchParam[0]
      * extension
        * url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
        * valueCode = #SHALL
      * name = "_id"
      * definition = "http://hl7.org/fhir/SearchParameter/Resource-id"
      * type = #token
      * documentation = "Allows searching for a Encounter by id"
    * searchParam[+]
      * extension
        * url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
        * valueCode = #SHALL
      * name = "organization"
      * definition = "http://hl7.org/fhir/SearchParameter/Encounter-location"
      * type = #reference
      * documentation = "Allows performing an _include on Location when retrieving an Encounter"
  * resource[+]
    * type = #Patient
    * supportedProfile = "http://hl7.org/fhir/us/davinci-crd/StructureDefinition/profile-patient"
    * interaction
      * extension
        * url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
        * valueCode = #SHOULD
      * code = #read
      * documentation = "Allows retrieval of the patient demographics if patient is not retrieved as part of pre-fetch.  (Support is mandatory if not supported as part of pre-fetch.)"
  * resource[+]
    * type = #Practitioner
    * supportedProfile = "http://hl7.org/fhir/us/davinci-crd/StructureDefinition/profile-practitioner"
    * interaction
      * extension
        * url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
        * valueCode = #SHOULD
      * code = #read
      * documentation = "Allows retrieval of ordering and/or performing provider's information if not retrieved as part of pre-fetch.  (Support is mandatory if not supported as part of pre-fetch.)"
  * resource[+]
    * type = #PractitionerRole
    * supportedProfile = "http://hl7.org/fhir/us/core/StructureDefinition/us-core-practitionerrole"
    * interaction
      * extension
        * url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
        * valueCode = #SHOULD
      * code = #search-type
      * documentation = "Allows retrieval of ordering and/or performing provider's (including associated Practitioners and Organizations) if not retrieved as part of pre-fetch.  (Support is mandatory if not supported as part of pre-fetch.)"
    * searchInclude[0] = "PractitionerRole:organization"
    * searchInclude[+] = "PractitionerRole:practitioner"
    * searchParam[0]
      * extension
        * url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
        * valueCode = #SHALL
      * name = "_id"
      * definition = "http://hl7.org/fhir/SearchParameter/Resource-id"
      * type = #token
      * documentation = "Allows searching for a PractitionerRole by id"
    * searchParam[+]
      * extension
        * url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
        * valueCode = #SHALL
      * name = "organization"
      * definition = "http://hl7.org/fhir/SearchParameter/PractitionerRole-organization"
      * type = #reference
      * documentation = "Allows performing an _include on Organization when retrieving a PractitionerRole"
    * searchParam[+]
      * extension
        * url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
        * valueCode = #SHALL
      * name = "practitioner"
      * definition = "http://hl7.org/fhir/SearchParameter/PractitionerRole-practitioner"
      * type = #reference
      * documentation = "Allows performing an _include on Practitioner when retrieving a PractitionerRole"
  * resource[+]
    * type = #Location
    * supportedProfile = "http://hl7.org/fhir/us/davinci-crd/StructureDefinition/profile-location"
    * interaction
      * extension
        * url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
        * valueCode = #SHOULD
      * code = #read
      * documentation = "Allows retrieval of the location associated with an order or appointment if not retrieved as part of pre-fetch.  (Support is mandatory if not supported as part of pre-fetch.)"
  * resource[+]
    * type = #MedicationRequest
    * supportedProfile = "http://hl7.org/fhir/us/davinci-crd/StructureDefinition/profile-medicationrequest"
    * interaction
      * extension
        * url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
        * valueCode = #SHOULD
      * code = #update
      * documentation = "Allows annotating the medication request in response to a card.  (Support is mandatory if the system supports MedicationRequests)"
    * versioning = #versioned-update
  * resource[+]
    * type = #NutritionOrder
    * supportedProfile = "http://hl7.org/fhir/us/davinci-crd/StructureDefinition/profile-nutritionorder"
    * interaction
      * extension
        * url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
        * valueCode = #SHOULD
      * code = #update
      * documentation = "Allows annotating the nutrition order in response to a card.  (Support is mandatory if the system supports NutritionOrders.)"
    * versioning = #versioned-update
  * resource[+]
    * type = #Organization
    * supportedProfile = "http://hl7.org/fhir/us/davinci-crd/StructureDefinition/profile-organization"
    * interaction
      * extension
        * url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
        * valueCode = #SHOULD
      * code = #read
      * documentation = "Allows retrieval of ordering and/or performing organization's information if not retrieved as part of pre-fetch.  (Support is mandatory if not supported as part of pre-fetch.)"
  * resource[+]
    * type = #ServiceRequest
    * supportedProfile = "http://hl7.org/fhir/us/davinci-crd/StructureDefinition/profile-servicerequest"
    * interaction
      * extension
        * url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
        * valueCode = #SHOULD
      * code = #update
      * documentation = "Allows annotating the service requests in response to a card.  (Support is mandatory if the system supports ServiceRequests.)"
    * versioning = #versioned-update
  * resource[+]
    * type = #ClaimResponse
    * supportedProfile = "http://hl7.org/fhir/us/davinci-hrex/StructureDefinition/hrex-claimresponse"
    * interaction
      * extension
        * url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
        * valueCode = #SHOULD
      * code = #create
      * documentation = "Needed to allow support for cards returning preemptive determiniations."
  * resource[+]
    * type = #Task
    * supportedProfile = "http://hl7.org/fhir/us/davinci-crd/StructureDefinition/profile-taskquestionnaire"
    * interaction
      * extension
        * url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
        * valueCode = #SHOULD
      * code = #create
      * documentation = "Needed to allow support for cards returning deferrable cards and/or requests to complete Questionnaires."
  * resource[+]
    * type = #VisionPrescription
    * supportedProfile = "http://hl7.org/fhir/us/davinci-crd/StructureDefinition/profile-visionprescription"
    * interaction
      * extension
        * url = "http://hl7.org/fhir/StructureDefinition/capabilitystatement-expectation"
        * valueCode = #SHOULD
      * code = #update
      * documentation = "Allows annotating the vision prescription in response to a card.  (Support is mandatory if the system supports VisionPrescriptions)"
    * versioning = #versioned-update