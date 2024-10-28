Profile: CRDTaskDispatch
Parent: Task
Id: profile-task-dispatch
Title: "CRD Dispatch Task"
Description: "This profile specifies constraints on the Task resource to capture details of dispatching a request to a particular performer."
* obeys crd-tsk-d1
* ^experimental = false
* ^extension[$fmm].valueInteger = 1
* status MS
* status = #draft (exactly)
* intent MS
* intent = #order (exactly)
* code = $task-code#fulfill
* focus 1.. MS
* focus only Reference(CRDServiceRequest)
* for 1.. MS
* for only Reference(CRDPatient)
* owner MS
* owner only Reference(USCorePractitionerProfile or HRexPractitionerRole or USCoreOrganizationProfile)
* location MS
* location only Reference(USCoreLocation)
* restriction MS
  * repetitions MS
  * period MS

Invariant: crd-tsk-d1
Description: "Must have at least one of owner and location"
Severity: #error
Expression: "owner.exists() or location.exists()"
