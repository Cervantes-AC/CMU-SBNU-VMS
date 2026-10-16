import Icon from "../../shared/ui/Icon";
import type { OpenDialog } from "../../shared/types";

export default function Emergency({ onSOS, onDialog }: { onSOS: () => void; onDialog: OpenDialog }) {
  return <section className="subpage emergency-page">
    <div className="emergency-hero"><div className="emergency-brand"><img src="/brand/odrrm.svg" alt="ODRRM logo" /><span>CMU Office of Disaster Risk<br/><b>Reduction & Management</b></span></div><div><span className="status-safe"><i /> Campus status: Normal</span><h2>Prepared. Connected.<br/>Ready to respond.</h2><p>Your direct link to CMU’s safety network, incident reporting, and verified emergency support.</p></div><button onClick={onSOS}><Icon name="alert" /><span><b>Request urgent help</b><small>Notify designated campus responders</small></span><Icon name="arrow" /></button></div>
    <div className="emergency-grid">
      <article className="panel"><span className="emergency-icon red"><Icon name="alert" /></span><h3>Report an incident</h3><p>Share safety concerns with optional location details and follow their status.</p><button onClick={() => onDialog("incident", "Report an incident", "Provide the incident type, location, and a clear description for ODRRM review.")}>Start a report <Icon name="arrow" /></button></article>
      <article className="panel"><span className="emergency-icon green"><Icon name="pin" /></span><h3>Incident map</h3><p>View authorized active advisories and safety points around campus.</p><button onClick={() => onDialog("map", "Campus incident map", "Authorized advisories and safety points currently visible on campus.")}>Open map <Icon name="arrow" /></button></article>
      <article className="panel"><span className="emergency-icon gold"><Icon name="heart" /></span><h3>Verified hotlines</h3><p>Access institution-verified contacts for campus and local support.</p><button onClick={() => onDialog("hotlines", "Verified emergency hotlines", "Call only institution-verified contacts listed below.")}>View hotlines <Icon name="arrow" /></button></article>
    </div>
    <div className="notice"><Icon name="shield" /><p><b>Important safety notice</b><span>SBNu SOS alerts notify designated CMU responders only. They do not directly contact public emergency services and response cannot be guaranteed.</span></p></div>
  </section>;
}
