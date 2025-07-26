Profile: CRDBaseBundle
Parent: Bundle
Id: profile-bundle-base
Title: "CRD Base Bundle"
Description: "This profile defines the common requirements for all CRD Bundles used as input to CDS Hooks calls."
* ^experimental = false
* ^abstract = true
* type = #collection
* total 0..0
* entry 1..* MS
  * fullUrl 1..1
  * resource 1..1
  * search 0..0
  * request 0..0
  * response 0..0

Profile: CRDAppointmentBundle
Parent: CRDBaseBundle
Id: profile-bundle-appointment
Title: "CRD Bundle of Appointments"
Description: "This profile defines the Bundle used for the appointment-book hook, expressing mustSupport for the CRD Appointment profile."
* ^experimental = false
* entry.resource only CRDAppointmentWithOrder or CRDAppointmentNoOrder

Profile: CRDRequestBundle
Parent: CRDBaseBundle
Id: profile-bundle-request
Title: "CRD Bundle of Request Resources"
Description: "This profile defines the Bundle used to convey the relevant orders for the order-select, order-sign, and order-dispatch hooks."
* ^experimental = false
* entry.resource only CRDAppointmentWithOrder or CRDAppointmentNoOrder or CRDCommunicationRequest or CRDDeviceRequest or CRDEncounter or CRDMedicationRequest or CRDNutritionOrder or CRDServiceRequest or CRDVisionPrescription

Profile: CRDTaskBundle
Parent: CRDBaseBundle
Id: profile-bundle-task
Title: "CRD Bundle of Dispatch Tasks"
Description: "This profile defines the Bundle used for the order-dispatch hook to convey the Tasks with the dispatching information."
* ^experimental = false
* entry.resource only CRDTaskDispatch

