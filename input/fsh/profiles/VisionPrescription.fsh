Profile: CRDVisionPrescription
Parent: $VisionPrescription
Id: profile-visionprescription
Title: "CRD Vision Prescription"
Description: "This profile defines an initial profile on the VisionPrescription resource to support coverage requirements discovery."
* ^experimental = false
* ^extension[$fmm].valueInteger = 1
* extension contains CRDCoverageInformation named Coverage-Information 0..* MS
* extension[Coverage-Information] ^short = "Coverage Info"
* identifier MS
//* status only code
* status MS
  * ^example.label = "General"
  * ^example.valueCode = #draft
  * ^comment = "This will be 'draft' when using order-select or an initial order-sign, but may be 'active' or other values for order-sign representing edits to the order or for order-dispatch."
* created MS
* patient MS
* patient only Reference(CRDPatient)
* encounter only Reference(CRDEncounter3_1 or CRDEncounter6_1)
* encounter MS
  * ^comment = "potentially relevant for CRD in some situations."
* dateWritten MS
* prescriber 1.. MS
* prescriber only Reference(USCorePractitionerProfile or HRexPractitionerRole)
* lensSpecification MS
  * product MS
  * eye MS
  * sphere MS
  * cylinder MS
  * axis MS
  * prism MS
    * amount MS
    * base MS
  * add MS
  * power MS
  * backCurve MS
  * diameter MS
  * duration MS