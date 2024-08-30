Instance: Encounter-example
InstanceOf: CRDEncounter6_1
//InstanceOf: CRDEncounter3_1
Title: "Encounter example"
Description: "Example encounter populated based on CRD profile"
Usage: #example
* id = "example"
* identifier
  * use = #official
  * system = "http://www.amc.nl/zorgportal/identifiers/visits"
  * value = "v1451"
* status = #in-progress
* class = $v3-ActCode#AMB "ambulatory"
* type = $sct#270427003 "Patient-initiated encounter"
* priority = $sct#310361003 "Non-urgent cardiological admission"
* subject = Reference(Patient/example)
* participant.individual = Reference(Practitioner/full)
* length = 140 'min' "min"
* reasonCode = $sct#34068001 "Heart valve replacement"
* hospitalization
  * preAdmissionIdentifier
    * use = #official
    * system = "http://www.amc.nl/zorgportal/identifiers/pre-admissions"
    * value = "93042"
  * admitSource = $sct#305956004 "Referral by physician"
  * dischargeDisposition = $sct#306689006 "Discharge to home"
* serviceProvider = Reference(Organization/example) "University Medical Center"