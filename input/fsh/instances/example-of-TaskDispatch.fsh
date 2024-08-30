Instance: task-dispatch-example
InstanceOf: CRDTaskDispatch
Title: "Dispatch Task example"
Description: "Example dispatch Task populated based on CRD profile"
Usage: #example
* status = #draft
* intent = #order
* focus = Reference(ServiceRequest/example)
* for = Reference(Patient/example)
* owner = Reference(http://example.org/fhir/Practitioner/full2) "Dr Cecil Surgeon"
* restriction.period.end = "2015-06-01"
