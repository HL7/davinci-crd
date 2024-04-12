Instance: example-of-CommunicationRequest
InstanceOf: CRDCommunicationRequest
Title: "CommunicationRequest example"
Description: "Example communication request populated based on CRD profile"
Usage: #example
* id = "example"
* identifier
  * system = "http://www.jurisdiction.com/insurer/123456"
  * value = "ABC123"
* basedOn.display = "EligibilityRequest"
* replaces.display = "prior CommunicationRequest"
* groupIdentifier.value = "12345"
* status = #draft
* category = $communication-category#instruction
* priority = #routine
* medium = $v3-ParticipationMode#WRITTEN "written"
  * text = "written"
* subject = Reference(Patient/example)
* encounter = Reference(Encounter/example)
* payload
  * extension[codeableConcept].valueCodeableConcept = $loinc#65752-8 "Liver Pathology biopsy report"
  * contentString = "Liver pathology biopsy report"
* occurrenceDateTime = "2016-06-10T11:01:10-08:00"
* authoredOn = "2016-06-10T11:01:10-08:00"
* requester = Reference(Practitioner/example)
* recipient = Reference(Organization/example)
* sender = Reference(http://example.org/fhir/someOtherProvider)