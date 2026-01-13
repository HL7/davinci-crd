This Implementation Guide (IG) is one of 4 HL7 Da Vinci IGs that are designed to address the challenges of automating the exchange of information between a provider and the responsible payer to determine coverage of services, items, and referrals. In particular, these IGs standardize the exchange of information required to automate the Prior Authorization (PA) process. The specific IG are:

1. Coverage Requirements Discovery (CRD) (this IG)
2. [Documentation Templates and Rules (DTR)](http://hl7.org/fhir/us/davinci-dtr)
3. [Prior Authorization Support (PAS)](http://hl7.org/fhir/us/davinci-pas)
4. [Clinical Documentation Exchange (CDex)](http://hl7.org/fhir/us/davinci-cdex)

Each guide supports a specific set of functions and exchanges required to determine payer coverage for specific services, items, and referrals.

To maximize the value of these IGs, it is imperative that each IG is integrated into clinical workflow at the appropriate point and all the exchanges required by each IG are fully supported by all the participants (providers, intermediaries, and payers).

§metric-1^crd-client,crd-server^storage:Each of these IGs recommends a set of metrics that **SHOULD** or **MAY** be collected by their respective implementations to facilitate the evaluation of adoption, functionality, processes, and improved outcomes.§ While there are current and proposed state requirements for prior authorization metric reporting, at the time of publication there is no requirement to report on the metrics defined here.  However, it is reasonable to believe that in the future interested entities (providers, payers, regulators, quality organizations, certification agencies, states, etc.) will ask for these metrics to evaluate the ongoing automation of the supported processes / exchanges. While this guide will not require these metrics to be captured in this release, the authors strongly recommend that each implementation do so with the expectation that collection and dissemination of these metrics may become a requirement ('SHALL') in future version of these IGs.

The table below defines a set of measures with a short name, purpose, conformance, stakeholder, and collection/calculation instructions that represent what the project group designing this IG felt would be both reasonably collectable and useful in evaluating implementations of this IG.  These measures are based on the [metric data model logical model](StructureDefinition-CRDMetricData.html) also published in this IG.

### Suggested Metrics

<table class="grid">
  <thead>
    <tr style="background-color:light-grey">
      <th>Nbr</th>
      <th>Metric</th>
      <th>Metric Type</th>
      <th>Provider/Payer</th>
      <th>Calculation Example</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>1</td>
      <td>Volume/% of Orders with results (coverage info) returned</td>
      <td>Adoption Process</td>
      <td>Both</td>
      <td>
        <i>For volume:</i><br/>
          <code>CRDMetricData.exists(response.coverageInfo).count()</code><br/>
        <i>For percent:</i><br/>
          Divide volume above by <code>CRDMetricData.where(httpResponse=200).count()</code> and express as percentage
      </td>
    </tr>
    <tr>
      <td>2</td>
      <td>% by coverage response type (covered, not covered,  conditional)</td>
      <td>Segmentation</td>
      <td>Both</td>
      <td>
        <i>For volume:</i><br/>
          Iterate where $ResponseType is one of covered, not-covered, conditional
          <code>CRDMetricData.exists(response.coverageInfo.where(covered=$ResponseType)).count()</code><br/>
        <i>For percent:</i><br/>
          Divide volume above by <code>CRDMetricData.where(httpResponse=200).count()</code> and express as percentage
      </td>
    </tr>
    <tr>
      <td>3</td>
      <td>Volume/% of PA required with DTR launch context</td>
      <td>Process Compliance</td>
      <td>Both</td>
      <td>
        <i>For volume:</i><br/>
          <code>CRDMetricData.exists(response.coverageInfo.where(paNeeded = "auth-needed" and questionnaire.exists())).count()</code><br/>
        <i>For percent:</i><br/>
          divide volume above by <code>CRDMetricData.exists(response.coverageInfo.where(paNeeded = 'auth-needed')).count()</code> and express as percentage
      </td>
    </tr>
    <tr>
      <td>4</td>
      <td>Volume/% of Documentation required with DTR launch context</td>
      <td>Adoption</td>
      <td>Both</td>
      <td>
        <i>For volume:</i><br/>
          <code>CRDMetricData.where(response.coverageInfo.where((docNeeded='clinical' or docNeeded='admin' or docNeeded='both') and questionnaire.exists())).count()</code><br/>
        <i>For percent:</i><br/>
          divide volume above by <code>CRDMetricData.exists(response.coverageInfo.where(docNeeded='clinical' or docNeeded='admin' or docNeeded='both')).count()</code> and express as percentage
      </td>
    </tr>
    <tr>
      <td>5</td>
      <td>Volume/% with service determination</td>
      <td>Adoption Process</td>
      <td>Both</td>
      <td>
        <i>For volume:</i><br/>
          <code>CRDMetricData.where(response.coverageInfo.exists(paNeeded = 'satisfied')).count()</code><br/>
        <i>For percent:</i><br/>
          divide volume above by <code>CRDMetricData.where(httpResponse=200).count()</code> and express as percentage
      </td>
    </tr>
    <tr>
      <td>6</td>
      <td>% in under 5 seconds</td>
      <td>Process Compliance</td>
      <td>Both</td>
      <td>
        <code>CRDMetricData.where(httpResponse=200 and (requestTime + 5 seconds > responseTime)).count() /<br/>
        CRDMetricData.where(httpResponse=200).count()</code> and express as percentage
      </td>
    </tr>
    <tr>
      <td>7</td>
      <td>Reduction in PA submission (relative to current practice)</td>
      <td>Outcome</td>
      <td>Both</td>
      <td>Needs information external to CRD metric data</td>
    </tr>
    <tr>
      <td>8</td>
      <td>All the above by payer for provider metrics and for provider for payer metrics</td>
      <td>Segmentation</td>
      <td>Both</td>
      <td>Segmentation based on CRDMetricData.source and (CRDMetricData.payerID or CRDMetricData.groupID)</td>
    </tr>
    <tr>
      <td>9</td>
      <td>All the above by hook type</td>
      <td>Segmentation</td>
      <td>Both</td>
      <td>Segmentation based on CRDMetricData.hookType</td>
    </tr>
  </tbody>
</table>