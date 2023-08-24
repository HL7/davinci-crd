ValueSet: CRDDeviceRequests
Id: deviceRequest
Title: "CRD Device Request Codes Value Set"
Description: """Codes for ordering devices.

NOTE: This value set contains many inappropriate codes because the underlying code systems do not provide a straight-forward mechanism to select only device-related codes and, given the evolving nature of the underlying code systems, strict enumeration is not a viable approach to defining the value set."""
* ^status = #active
* ^experimental = false
* ^copyright = "Current Procedural Terminology (CPT) is copyright 2020 American Medical Association. All rights reserved."
* include codes from system $cpt
* include codes from system $HCPCSReleaseCodeSets