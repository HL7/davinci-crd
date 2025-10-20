Profile: CRDAppointmentBase
Parent: $Appointment
Id: profile-appointment-base
Title: "CRD Base Appointment"
Description: "This profile specifies extensions and constraints on the Appointment resource to support coverage requirements discovery."
* obeys crd-apt1 and crd-apt2
* ^experimental = false
* ^abstract = true
* contained MS
  * ^comment = "Any references found in this resource, with the exception of 'Patient' could potentially be resource-specific and thus transmitted as contained resources."
* status MS
  * ^short = "Appointment status"
  * ^example.label = "General"
  * ^example.valueCode = #proposed
  * ^comment = "This will be 'proposed' when using an initial appointment-book, but may be 'booked' or other values for appointment-book representing edits to the appointment."
* start MS
  * ^condition[+] = crd-apt1
* end MS
  * ^condition[+] = crd-apt2
* participant MS
  * actor MS
    * ^short = "Patient, Practitioner  or Location"
  * actor only Reference(CRDPatient or USCorePractitionerProfile or USCorePractitionerRoleProfile or CRDLocation)
// TODO: Add RelatedPerson?
  * status MS
* requestedPeriod 0..1 MS
  * ^condition[+] = crd-apt1
  * ^condition[+] = crd-apt2

Invariant: crd-apt1
Description: "Must have either start or requestedPeriod.start"
Severity: #error
Expression: "start.exists() or requestedPeriod.start.exists()"

Invariant: crd-apt2
Description: "Must have either end or requestedPeriod.end"
Severity: #error
Expression: "end.exists() or requestedPeriod.end.exists()"


Profile: CRDAppointmentWithOrder
Parent: CRDAppointmentBase
Id: profile-appointment-with-order
Title: "CRD Appointment with Order"
Description: "An appointment where the details of what the appointment is being booked for are provided in the associated ServiceRequest"
* ^extension[$fmm].valueInteger = 1
* ^experimental = false
* ^abstract = false
* basedOn 1.. MS
* basedOn only Reference(CRDServiceRequest or CRDMedicationRequest or CRDDeviceRequest)
  * ^comment = "Potentially relevant for CRD in some situations.  Must Support only applies if the client supports the given type of order and also ties their appointments directly to that type of order."

Profile: CRDAppointmentNoOrder
Parent: CRDAppointmentBase
Id: profile-appointment-no-order
Title: "CRD Appointment without Order"
Description: "An appointment where the details of what the appointment is being booked for are provided inline and there is no associated ServiceRequest"
* ^extension[$fmm].valueInteger = 1
* ^experimental = false
* ^abstract = false
* extension contains CRDCoverageInformation named Coverage-Information 0..* MS
* identifier MS
* serviceCategory MS
* serviceType MS
  * extension contains CRDBillingOptions named BillingOptions 0..* MS
  * extension[BillingOptions] ^short = "Expected Billing Code(s)"
* specialty MS
* appointmentType MS
* reasonReference MS
//* reasonReference only Reference(USCoreConditionProblemsHealthConcernsProfile or USCoreConditionUSCoreConditionEncounterDiagnosisProfile or USCoreProcedureProfile)
  * ^comment = "Potentially relevant for CRD in some situations."
