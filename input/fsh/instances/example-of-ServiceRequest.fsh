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
  * extension[+]
    * url = Canonical(CRDBillingOptions)
    * valueCodeableConcept = $cpt#0795T
  * extension[+]
    * url = Canonical(CRDBillingOptions)
    * valueCodeableConcept = $cpt#0796T
  * extension[+]
    * url = Canonical(CRDBillingOptions)
    * valueCodeableConcept = $cpt#0797T
  * extension[+]
    * url = Canonical(CRDBillingOptions)
    * valueCodeableConcept = $cpt#0804T
  * extension[+]
    * url = Canonical(CRDBillingOptions)
    * valueCodeableConcept = $cpt#0823T
  * extension[+]
    * url = Canonical(CRDBillingOptions)
    * valueCodeableConcept = $cpt#0915T
  * text = "Implant Pacemaker"
* subject = Reference(Patient/example)
* authoredOn = "2015-03-30"
* requester = Reference(Practitioner/full) "Dr. Beverly Crusher"
* performer = Reference(http://example.org/fhir/Practitioner/full2) "Dr Cecil Surgeon"
* locationReference = Reference(Location/example)
* reasonCode = $sct#48867003 "Bradycardia"