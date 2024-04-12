Instance: example-of-DeviceRequest
InstanceOf: CRDDeviceRequest
Title: "DeviceRequest example"
Description: "Example devicerequest populated based on CRD profile"
Usage: #example
* id = "example"
* basedOn = Reference(http://example.org/fhir/ServiceRequest/someReferral)
* status = #draft
* intent = #original-order
* codeReference = Reference(Device/example)
* subject = Reference(Patient/example)
* authoredOn = "2016-06-10T11:01:10-08:00"
* requester = Reference(Practitioner/example)