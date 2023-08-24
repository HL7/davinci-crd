Profile: NutritionOrder
Parent: $NutritionOrder
Id: profile-nutritionorder
Title: "CRD Nutrition Order"
Description: "This profile specifies extensions and constraints on the NutritionOrder resource to support coverage requirements discovery."
* ^version = "1.1.0-ci-build"
* ^status = #active
* ^experimental = false
* ^date = "2023-05-30T11:47:53-07:00"
* ^publisher = "HL7 International - Financial Management Work Group"
* ^contact.telecom.system = #url
* ^contact.telecom.value = "http://www.hl7.org/Special/committees/fm"
* ^jurisdiction = urn:iso:std:iso:3166#US
* ^extension[$fmm].valueInteger = 1
* extension contains CoverageInformation named Coverage-Information 0..* MS
* extension[Coverage-Information] ^short = "Coverage Info"
* identifier MS
* status only code
* status = #draft (exactly)
* status MS
* patient only Reference(Patient)
* patient MS
* encounter only Reference(Encounter)
* encounter MS
  * ^comment = "potentially relevant for CRD in some situations."
* dateTime MS
* orderer 1.. MS
* orderer only Reference(Practitioner or USCorePractitionerRoleProfile)
* allergyIntolerance MS
* foodPreferenceModifier MS
* excludeFoodModifier MS
* oralDiet MS
* supplement MS
* enteralFormula MS