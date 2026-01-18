Instance: example-of-DeviceRequest
InstanceOf: CRDDeviceRequest
Title: "DeviceRequest example"
Description: "Example DeviceRequest populated based on CRD profile"
Usage: #example
* id = "example"
* extension[EncounterCategory].valueCodeableConcept = $v3-ActCode#HH "home health"
* extension[ServiceCategory].valueCodeableConcept = $x12-1365#18 "Durable Medical Equipment Rental"
* basedOn = Reference(http://example.org/fhir/ServiceRequest/someReferral)
* status = #draft
* intent = #original-order
* codeReference = Reference(Device/example)
* subject = Reference(Patient/example)
* authoredOn = "2016-06-10T11:01:10-08:00"
* requester = Reference(Practitioner/full)