Instance: example-of-ServiceRequest
InstanceOf: CRDServiceRequest
Title: "ServiceRequest example"
Description: "Example service request populated based on CRD profile"
Usage: #example
* id = "example"
* basedOn = Reference(http://example.org/fhir/ServiceRequest/someReferral)
* status = #draft
* intent = #order
* code = $sct#25267002 "Insertion of intracardiac pacemaker (procedure)"
  * text = "Implant Pacemaker"
* subject = Reference(Patient/example)
* authoredOn = "2015-03-30"
* requester = Reference(Practitioner/example) "Dr. Beverly Crusher"
* performer = Reference(http://example.org/fhir/Practitioner/example2) "Dr Cecil Surgeon"
* locationReference = Reference(Location/example)
* reasonCode = $sct#48867003 "Bradycardia"