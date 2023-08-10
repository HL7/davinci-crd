<div markdown="1" class="new-content">

This Implementation Guide (IG) is one of 4 HL7 Da Vinci IGs that are designed to address the challenges of automating the exchange of information between a provider and the responsible payer to determine coverage of services, items, and referrals. In particular, these IGs standardize the exchange of information required to automate the Prior Authorization (PA) process. The specific IG are:

1. Coverage Requirements Discovery (CRD) (this IG)
2. [Documentation Templates and Rules (DTR)](http://hl7.org/fhir/us/davinci-dtr)
3. [Prior Authorization Support (PAS)](http://hl7.org/fhir/us/davinci-pas)
4. [Clinical Documentation Exchange (CDex)](http://hl7.org/fhir/us/davinci-cdex)

Each guide supports a specific set of functions and exchanges required to determine payer coverage for specific services, items, and referrals.

To maximize the value of these IGs, it is imperative that each IG is integrated into clinical workflow at the appropriate point and all of the exchanges required by each IG are fully supported by all of the participants (providers, intermediaries, and payers).

Each of these IGs recommends a set of metrics that **SHOULD** or **MAY** be collected by their respective implementations to facilitate the evaluation of adoption, functionality, processes, and improved outcomes. While there is currently no requirement to report on these metrics, it is reasonable to believe that in the future interested entities (providers, payers, regulators, quality organizations, certification agencies, states, etc.) will ask for these metrics to evaluate the ongoing automation of the supported processes / exchanges. While this guide will not require these metrics to be captured in this release, the authors strongly suggest each implementation should do so with the expectation that collection and dissemination of these metrics may become a requirement (SHALL) in future version of these IGs.

The table below defines a set of measures with a short name, purpose, conformance, stakeholder, and collection/calculation instructions that represent what the project group designing this IG felt would be both reasonably collectable and useful in evaluating implementations of this IG.  These measures are based on the [metric data model logical model](StructureDefinition-CRDMetricData.html) also published in this IG.

### Suggested Metrics

<table class="grid">
  <thead>
    <tr style="background-color:light-grey">
      <th>No</th>
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
          count where CRDMetricData.response.coverageInfo &gt; 0<br/>
        <i>For percent:</i><br/>
          divide by count of CRDMetricData.httpResponse = "200" and express as percentage
      </td>
    </tr>
    <tr>
      <td>2</td>
      <td>% by response type (covered, not covered,  conditional, PA required)</td>
      <td>Segmentation</td>
      <td>Both</td>
      <td>
        <i>For volume:</i><br/>
          count where CRDMetricData.response.coverageInfo.covered = [one of the codes]<br/>
        <i>For percent:</i><br/>
          divide volume by count where CRDMetricData.httpResponse = 200 and express as percentage
      </td>
    </tr>
    <tr>
      <td>3</td>
      <td>Volume/% of PA required with DTR launch context</td>
      <td>Process Compliance</td>
      <td>Both</td>
      <td>
        <i>For volume:</i><br/>
          count where (CRDMetricData.cards.coverageInfo.pa-needed = "auth-needed" and CRDMetricData.cards.coverageInfo.questionnaie &gt; 0)<br/>
        <i>For percent:</i><br/>
          divide by count of (CRDMetricData.cards.coverageInfo.pa-needed = "auth-needed" and express as percentage
      </td>
    </tr>
    <tr>
      <td>4</td>
      <td>Volume/% of Documentation required with DTR launch context</td>
      <td>Adoption</td>
      <td>Both</td>
      <td>
        <i>For volume:</i><br/>
          count where (CRDMetricData.cards.coverageInfo.doc-needed = "yes" and CRDMetricData.cards.coverageInfo.questionnaie &gt; 0)<br/>
        <i>For percent:</i><br/>
          divide by count of (CRDMetricData.cards.coverageInfo.doc-needed = "yes" and express as percentage
      </td>
    </tr>
    <tr>
      <td>5</td>
      <td>Volume/% with service determination</td>
      <td>Adoption Process</td>
      <td>Both</td>
      <td>
        <i>For volume:</i><br/>
          count where CRDMetricData.response.coverageInfo.pa-needed = "satisfied"<br/>
        <i>For percent:</i><br/>
          divide by count of CRDMetricData.httpResponse = 200 and express as percentage
      </td>
    </tr>
    <tr>
      <td>6</td>
      <td>% in under 5 seconds</td>
      <td>Process Compliance</td>
      <td>Both</td>
      <td>
        count where (((CRDMetricData.responseTime - CRDMetricData.requestTime) &lt; 5 seconds) and CRDMetricData.httpResponse = 200)<br/>
        divide by count of all CRD items where CRDMetricData.httpResponse = 200 and express as percentage
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
      <td>All of the above by payer for provider metrics and for provider for payer metrics</td>
      <td>Segmentation</td>
      <td>Both</td>
      <td>Segmentation based on CRDMetricData.source and (CRDMetricData.payerID or CRDMetricData.groupID)</td>
    </tr>
    <tr>
      <td>9</td>
      <td>All of the above by hook type</td>
      <td>Segmentation</td>
      <td>Both</td>
      <td>Segmentation based on CRDMetricData.hookType</td>
    </tr>
  </tbody>
</table>

</div>