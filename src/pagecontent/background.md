### Underlying technologies

This guide is based on the [HL7 FHIR]({{site.data.fhir.path}}index.html) standard, as well as the [CDS Hooks](https://cds-hooks.hl7.org) and [SMART on FHIR](http://hl7.org/fhir/smart-app-launch) specifications, which build additional capabilities on top of FHIR.  This architecture is intended to maximize the number of clinical systems that conform to this guide as well as to allow for easy growth and extensibility of system capabilities in the future.

Implementers of this specification therefore need to understand some basic information about these specifications.


#### FHIR

This implementation guide uses terminology, notations and design principles that are
specific to FHIR.  Before reading this implementation guide, it's important to be familiar with some of the basic principles of FHIR as well
as general guidance on how to read FHIR specifications.  Readers who are unfamiliar with FHIR are encouraged to read (or at least skim) the following
prior to reading the rest of this implementation guide.

* [FHIR overview]({{site.data.fhir.path}}overview.html)
* [Developer's introduction]({{site.data.fhir.path}}overview-dev.html)
* (or [Clinical introduction]({{site.data.fhir.path}}overview-clinical.html))
* [FHIR data types]({{site.data.fhir.path}}datatypes.html)
* [Using codes]({{site.data.fhir.path}}terminologies.html)
* [References between resources]({{site.data.fhir.path}}references.html)
* [How to read resource & profile definitions]({{site.data.fhir.path}}formats.html)
* [Base resource]({{site.data.fhir.path}}resource.html)

This implementation guide also leverages the US Core set of profiles defined by HL7 for sharing human EHR data in the US.  Additional information is located at: [US-Core]({{site.data.fhir.path}}hooks.html#us-core)

This implementation guide supports the [STU3](http://hl7.org/fhir/STU3) and [R4]({{site.data.fhir.path}}index.html) versions of the FHIR standard. FHIR services based on STU3 are being moved into production by EHR vendors. R4 is just recently published and the goal is to ensure the implementation guide is aligned with the current direction of the FHIR standard. Initial implementations will focus on STU3.

This implementation guide also builds on the US Core Implementation Guide and implementers need to familiarize themselves with the profiles in those Implementation Guides:
<table>
  <tr>
    <td>FHIR R4 US Core (not yet created)</td>
  </tr>
  <tr>
    <td><a href="http://hl7.org/fhir/us/core/1.0.1">FHIR STU3 US Core (1.0.1)</a></td>
  </tr>
</table>


Implementers should also familiarize themselves with the FHIR resources used within the guide:

<table>
  <thead>
    <tr>
      <th>STU3</th>
      <th>R4</th>
    </tr>
  </thead>
  <tr>
    <td>
      <a href="http://hl7.org/fhir/STU3/appointment.html">Appointment</a><br/>
      <a href="http://hl7.org/fhir/STU3/coverage.html">Coverage</a><br/>
      <a href="http://hl7.org/fhir/STU3/communicationrequest.html">CommunicationRequest</a><br/>
      <a href="http://hl7.org/fhir/STU3/device.html">Device</a><br/>
      <a href="http://hl7.org/fhir/STU3/devicerequest.html">DeviceRequest</a><br/>
      <a href="http://hl7.org/fhir/STU3/encounter.html">Encounter</a><br/>
      <a href="http://hl7.org/fhir/STU3/location.html">Location</a><br/>
      <a href="http://hl7.org/fhir/STU3/organization.html">Organization</a><br/>
      <a href="http://hl7.org/fhir/STU3/medication.html">Medication</a><br/>
      <a href="http://hl7.org/fhir/STU3/medicationrequest.html">MedicationRequest</a><br/>
      <a href="http://hl7.org/fhir/STU3/nutritionorder.html">NutritionOrder</a><br/>
      <a href="http://hl7.org/fhir/STU3/patient.html">Patient</a><br/>
      <a href="http://hl7.org/fhir/STU3/practitioner.html">Practitioner</a><br/>
      <a href="http://hl7.org/fhir/STU3/practitionerrole.html">PractitionerRole</a><br/>
      <a href="http://hl7.org/fhir/STU3/procedurerequest.html">ProcedureRequest</a><br/>
      <a href="http://hl7.org/fhir/STU3/questionnaire.html">Questionnaire</a><br/>
      <a href="http://hl7.org/fhir/STU3/referralrequest.html">ReferralRequest</a><br/>
      <a href="http://hl7.org/fhir/STU3/supplyrequest.html">SupplyRequest</a><br/>
      <a href="http://hl7.org/fhir/STU3/task.html">Task</a><br/>
      <a href="http://hl7.org/fhir/STU3/visionprescription.html">VisionPrescription</a>
    </td>
    <td>
      <a href="{{site.data.fhir.path}}appointment.html">Appointment</a><br/>
      <a href="{{site.data.fhir.path}}coverage.html">Coverage</a><br/>
      <a href="{{site.data.fhir.path}}communicationrequest.html">CommunicationRequest</a><br/>
      <a href="{{site.data.fhir.path}}device.html">Device</a><br/>
      <a href="{{site.data.fhir.path}}devicerequest.html">DeviceRequest</a><br/>
      <a href="{{site.data.fhir.path}}encounter.html">Encounter</a><br/>
      <a href="{{site.data.fhir.path}}location.html">Location</a><br/>
      <a href="{{site.data.fhir.path}}organization.html">Organization</a><br/>
      <a href="{{site.data.fhir.path}}medication.html">Medication</a><br/>
      <a href="{{site.data.fhir.path}}medicationrequest.html">MedicationRequest</a><br/>
      <a href="{{site.data.fhir.path}}nutritionorder.html">NutritionOrder</a><br/>
      <a href="{{site.data.fhir.path}}patient.html">Patient</a><br/>
      <a href="{{site.data.fhir.path}}practitioner.html">Practitioner</a><br/>
      <a href="{{site.data.fhir.path}}practitionerrole.html">PractitionerRole</a><br/>
      <a href="{{site.data.fhir.path}}questionnaire.html">Questionnaire</a><br/>
      <a href="{{site.data.fhir.path}}servicerequest.html">ServiceRequest</a><br/>
      <a href="{{site.data.fhir.path}}supplyrequest.html">SupplyRequest</a><br/>
      <a href="{{site.data.fhir.path}}task.html">Task</a><br/>
    </td>
  </tr>
</table>

#### CDS Hooks
Clinical systems will use the specification and workflows defined by [CDS Hooks](https://cds-hooks.hl7.org) to initiate Coverage Requirements Discovery with the payers. Implementers should be familiar with this specification.


#### SMART on FHIR
Client systems conformant to this implementation guide SHALL also serve as a SMART on FHIR client.  This is to allow coverage discovery functionality to be invoked outside of regular clinical workflows using a SMART on FHIR application to provide a consistent way of edvaluating "what if?" scenarios across EHR implementations.  As such client implementers will also need to be familiar with the [SMART on FHIR](http://hl7.org/fhir/smart-app-launch) specification.  Because the SMART on FHIR app will interact with payer systems through the CDS Hooks interface, payer implementers only need to be familiar with the SMART on FHIR specification if they plan to develop SMART apps for launch by CDS Hooks or for other purposes.
