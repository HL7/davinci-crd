Profile: CRDNutritionOrder
Parent: $NutritionOrder
Id: profile-nutritionorder
Title: "CRD Nutrition Order"
Description: "This profile specifies extensions and constraints on the NutritionOrder resource to support coverage requirements discovery."
* ^experimental = false
* ^extension[$fmm].valueInteger = 1
* extension contains CRDCoverageInformation named Coverage-Information 0..* MS
* extension[Coverage-Information] ^short = "Coverage Info"
* identifier MS
//* status only code
* status MS
* status = #draft (exactly)
* patient MS
* patient only Reference(CRDPatient)
* encounter MS
* encounter only Reference(CRDEncounter3_1 or CRDEncounter6_1)
  * ^comment = "potentially relevant for CRD in some situations."
* dateTime MS
* orderer 1.. MS
* orderer only Reference(USCorePractitionerProfile or HRexPractitionerRole)
* allergyIntolerance MS
* foodPreferenceModifier MS
* excludeFoodModifier MS
* oralDiet MS
* supplement MS
* enteralFormula MS