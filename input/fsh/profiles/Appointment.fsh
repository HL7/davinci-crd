Profile: CRDAppointment
Parent: $Appointment
Id: profile-appointment
Title: "CRD Appointment"
Description: "This profile specifies extensions and constraints on the Appointment resource to support coverage requirements discovery."
* ^experimental = false
* extension contains CRDCoverageInformation named Coverage-Information 0..* MS
* extension[Coverage-Information] ^short = "Coverage Info"
* identifier MS
* status MS
  * ^short = "Appointment status"
  * ^example.label = "General"
  * ^example.valueCode = #proposed
* serviceCategory MS
* serviceType MS
* specialty MS
* appointmentType MS
* reasonReference MS
//* reasonReference only Reference(USCoreConditionProblemsHealthConcernsProfile or USCoreConditionUSCoreConditionEncounterDiagnosisProfile or USCoreProcedureProfile)
  * ^comment = "potentially relevant for CRD in some situations."
* start 1.. MS
* end 1.. MS
* basedOn only Reference(CRDServiceRequest)
  * ^comment = "potentially relevant for CRD in some situations."
* participant MS
  * actor MS
    * ^short = "Patient, Practitioner  or Location"
  * actor only Reference(CRDPatient or USCorePractitionerProfile or USCorePractitionerRoleProfile or CRDLocation)
// TODO: Add RelatedPerson?
  * status MS
* requestedPeriod 1..1 MS