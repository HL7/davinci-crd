Instance: example-of-Appointment1
InstanceOf: CRDAppointmentWithOrder
Title: "Appointment ServiceRequest example"
Description: "Example appointment tied to a ServiceRequest based on CRD profile"
Usage: #example
* id = "example1"
* status = #proposed
* appointmentType = $v2-0276#FOLLOWUP "A follow up visit from a previous appointment"
* reasonReference = Reference(http://example.org/fhir/Condition/example) "Heart problem"
* priority = 5
* description = "Discussion on the results of your recent MRI"
* start = "2013-12-10T09:00:00Z"
* end = "2013-12-10T11:00:00Z"
* created = "2013-10-10"
* comment = "Further expand on the results of the MRI and determine the next actions that may be appropriate."
* basedOn = Reference(ServiceRequest/example)
* participant[Patient]
  * actor = Reference(Patient/example) "Amy Baxter"
  * status = #accepted
* participant[PrimaryPerformer]
  * actor = Reference(Practitioner/full) "Dr Adam Careful"
  * status = #accepted
* requestedPeriod
  * start = "2020-11-01"
  * end = "2020-12-15"

Instance: example-of-Appointment2
InstanceOf: CRDAppointmentNoOrder
Title: "Appointment example"
Description: "Example stand-alone appointment populated based on CRD profile"
Usage: #example
* id = "example2"
* status = #proposed
* serviceCategory[+] = $sct#386053000 "Evaluation procedure (procedure)"
* serviceCategory[+] = $v3-ActCode#AMB "ambulatory"
* serviceCategory[+] = $x12-1365#3 "Consultation"
* serviceType = $service-type#124 "General Practice"
* specialty = $sct#394814009 "General practice (specialty)"
* appointmentType = $v2-0276#FOLLOWUP "A follow up visit from a previous appointment"
* reasonReference = Reference(http://example.org/fhir/Condition/example) "Heart problem"
* priority = 5
* description = "Discussion on the results of your recent MRI"
* start = "2013-12-10T09:00:00Z"
* end = "2013-12-10T11:00:00Z"
* created = "2013-10-10"
* comment = "Further expand on the results of the MRI and determine the next actions that may be appropriate."
* participant[Patient]
  * actor = Reference(Patient/example) "Amy Baxter"
  * status = #accepted
* participant[PrimaryPerformer]
  * actor = Reference(Practitioner/full) "Dr Adam Careful"
  * status = #accepted
* requestedPeriod
  * start = "2020-11-01"
  * end = "2020-12-15"