Profile: CRDDevice
Parent: $Device
Id: profile-device
Title: "CRD Device"
Description: "This profile specifies additional constraints on the US Core Device Profile to support coverage requirements discovery."
* ^experimental = false
* udiCarrier ..1 MS
  * deviceIdentifier MS
* property MS
  * type MS
  * valueQuantity MS
  * valueCode MS