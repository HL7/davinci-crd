Profile: CRDMedication
Parent: USCoreMedicationProfile
Id: profile-medication
Title: "CRD Medication"
Description: "This profile specifies additional constraints on the US Core Medication Profile to support coverage requirements discovery."
* ^experimental = false
* code
  * extension contains CRDBillingOptions named BillingOptions 0..* MS
  * extension[BillingOptions] ^short = "Expected Billing Code(s)"
