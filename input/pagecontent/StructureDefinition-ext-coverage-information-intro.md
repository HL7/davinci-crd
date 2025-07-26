<!--- Text entered into this file will appear at the top of the profiles page before the Formal Views of the profile content. -->

<div class="new-content">
<a name="introduction"> </a>
<h3>Introduction</h3>

<p>
This extension is added to FHIR Request and other resources as part of the CRD <a href="cards.html#coverage-information-response-type">Coverage Information Response Type</a>.
</p>

<p>
The process of describing the applicable coverage rules for a given product or service can be complex, so this extension includes
quite a few components.
</p>

<p>
The primary purpose of this extension is to convey three things:
</p>
<ol>
  <ul>Is the product/service covered under the patient's coverage? (<b>covered</b>)</ul>
  <ul>If covered (or possibly covered), under the patient's coverage, is prior authorization necessary? (<b>pa-needed</b>)</ul>
  <ul>Is there additional information that needs to be covered that will be needed for: prior authorization processing, claims adjudication, appropriate use review, by the performer for any of the preceding reasons, or for some other purpose? (<b>doc-needed</b>)</ul>
</ol>

<p>
All of the remaining elements are used to provide support for those three primary elements.  There are several types of support.
</p>
<a name="scoping"> </a>
<h4>Scoping elements</h4>
<p>These elements limit the applicability of the statement being made.  For example, if the statement is "covered, no prior authorization required", that assertion could be based on certain assumptions, such as the service being billed in a particular way or being performed in a particular time period time.  There can be multiple coverage-information repetitions that each have distinct scoping elements.  When this occurs, the interpretation is "if the scoping elements for the first coverage-information are true, the rules for coverage/authorization/etc. are defined in that coverage-information instance, otherwise keep looking for rules in subsequent coverage repetitions".  The union of the scoping elements in each coverage-information repetition <b>SHOULD</b> be disjoint.  I.e. for a given performed service, there should be a single coverage-information repetition that applies.</p>
<p>NOTE: The coverage information repetitions may not provide full coverage.  For example, it's possible that the eventual billed code will fall outside the list of billing codes and/or date ranges of any of the coverage-information repetitions present.  In that situation, no inference can be made about the coverage, prior authorization, or documentation requirements for the performed service.</p>
<ul>
  <li><b>billingCode</b> indicates the specific billing (codes) the coverage assertion applies to.  This reflects the fact that the code used for an ordered product or service could vary from the ordered code.  This is especially useful if the ordered code isn't already a 'billing' code, but even if the ordered code <i>is</i> a billing code, the performed code might still vary.</li>
  <li><b>detail</b> can have multiple uses.  If the <code>detail.category</code> is 'limitation', then it acts as a scoping limitation.  For example, limitation to quantity or performance period</li>
  <li><b>dependency</b> indicates that the assertion is dependent on the occurrence of one or more other orders.  For example, coverage for post-surgery rehabilitation might be dependent on the associated surgery proceeding as planned</li>
  <li><b>expiry-date</b> is the date after which the provided coverage information should no longer be considered valid (typically when the patient's coverage ends or when coverage policies could change)</li>
</ul>

<a name="detail"> </a>
<h4>Detail elements</h4>
<p>These elements provide additional details about the assertion being made, such as what type of documentation is needed</p>
<ul>
  <li><b>doc-purpose</b> indicates the purposes for which additional documentation is needed when <i>doc-needed</i> is indicated</li>
  <li><b>info-needed</b> indicates the nature of additional information that is necessary to make a decision about coverage, prior authorization, or documentation in situations where one or more of <i>covered</i>, <i>pa-needed</i>, or <i>doc-needed</i> is set to 'conditional'.</li>
  <li><b>reason</b> indicates why the coverage decisions made apply.  These would typically be reasons for no coverage, why prior auth is necessary, or why documentation is needed. But it could also convey why prior authorization is NOT necessary (e.g. gold carded provider).  If one or more of the key decisions is "conditional", this will convey the details of the rules.  If there are multiple reason repetitions, each repetition <b>SHOULD</b> make clear exactly what aspect of the coverage information assertion the reason applies to.</li>
  <li><b>detail</b> can have multiple uses.  If the <code>detail.category</code> is 'decisional' or 'other', then the information provides additional detail, such as instructions for claim or authorization submission, copay information, etc.</li>
  <li><b>questionnaire</b> indicates the questionnaire(s) to be completed in situations where <i>doc-needed</i> is flagged.  (Note that DTR is capable of determining the set of questionnaires if they aren't listed in the coverage-information extension.)</li>
  <li><b>satisfied-pa-id</b> is the authorization number that applies if the <i>pa-needed</i> element is 'satisfied'</li>
</ul>

<a name="metadata"> </a>
<h4>Metadata elements</h4>
<p>Additional information related to this specific coverage assertion, such as when it was made or where to reach out for additional details.</p>
<ul>
  <li><b>date</b> indicates when the assertion was made</li>
  <li><b>coverage-assertion-id</b> is a unique number for the coverage assertion </li>
  <li><b>contact</b> is how to reach out if there are questions or a need for additional support with respect to the provided coverage information</li>
  <li><b></b></li>
</ul>
<ul>
  <li>'Coverage' indicates which insurance coverage the coverage information applies to.  (In some cases, a service might make assertions for multiple coverages.)</li>
  <li></li>
</ul>

</div>
