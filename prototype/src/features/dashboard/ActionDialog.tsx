import { useState } from "react";
import Icon from "../../shared/ui/Icon";
import type { DialogKind, DialogState } from "../../shared/types";
import { activities } from "../activities/data";

export default function ActionDialog({ dialog, close, complete }: { dialog: NonNullable<DialogState>; close: () => void; complete: (kind: DialogKind, message: string) => void }) {
  const [mapList, setMapList] = useState(false);
  const formKinds: DialogKind[] = ["activity", "volunteer", "incident", "attendance", "announcement", "report", "settings", "profile"];
  const isForm = formKinds.includes(dialog.kind);
  const submit = (e: React.FormEvent) => {
    e.preventDefault();
    const messages: Record<DialogKind, string> = {
      activity: "Activity created and saved as a draft.",
      volunteer: "Volunteer profile added successfully.",
      incident: "Incident report submitted to ODRRM for review.",
      attendance: "QR attendance session is now active.",
      announcement: "Announcement published successfully.",
      report: "Report generated and downloaded.",
      settings: "Workspace preferences saved.",
      profile: "Profile information updated.",
      map: "", hotlines: "", notifications: "", pulse: "",
    };
    complete(dialog.kind, messages[dialog.kind]);
  };
  return <div className="modal-backdrop" onMouseDown={close}>
    <div className="action-modal" onMouseDown={(e) => e.stopPropagation()}>
      <div className="action-modal-head"><div><span className="kicker">CMU SBNu workspace</span><h2>{dialog.title}</h2><p>{dialog.description}</p></div><button className="modal-close" onClick={close} aria-label="Close"><Icon name="x" /></button></div>
      {dialog.kind === "map" && <div className="map-dialog">
        {!mapList ? <div className="map-canvas"><span className="map-road road-one" /><span className="map-road road-two" /><span className="map-road road-three" /><i className="map-pin pin-one"><Icon name="shield" /></i><i className="map-pin pin-two"><Icon name="heart" /></i><div className="map-campus">CMU Main Campus<small>2 safety points · No active incidents</small></div></div> : <div className="map-list"><div><Icon name="shield" /><span><b>ODRRM Operations Center</b><small>Open · Administration Building</small></span></div><div><Icon name="heart" /><span><b>University Infirmary</b><small>Open 24 hours · South Campus</small></span></div></div>}
        <button className="secondary-btn full-btn" onClick={() => setMapList(!mapList)}>{mapList ? "Return to map" : "Switch to accessible list view"}</button>
      </div>}
      {dialog.kind === "hotlines" && <div className="hotline-list">
        {[["CMU ODRRM", "(088) 356-1910", "tel:+63883561910"], ["University Infirmary", "(088) 356-1921", "tel:+63883561921"], ["National Emergency", "911", "tel:911"]].map(([name, number, href]) => <div key={name}><span><b>{name}</b><small>Verified October 2026 · Available now</small></span><strong>{number}</strong><a href={href}>Call</a></div>)}
      </div>}
      {dialog.kind === "notifications" && <div className="notification-list">
        <div><span className="notification-dot" /><p><b>Activity reminder</b><span>Disaster Preparedness Drill begins in 4 days.</span><small>12 minutes ago</small></p></div>
        <div><span className="notification-dot gold" /><p><b>New volunteer application</b><span>Three profiles are ready for coordinator review.</span><small>1 hour ago</small></p></div>
        <div><Icon name="check" /><p><b>Attendance synced</b><span>River Clean-up Drive records were updated.</span><small>Yesterday</small></p></div>
        <button className="secondary-btn full-btn" onClick={() => complete("notifications", "All notifications marked as read.")}>Mark all as read</button>
      </div>}
      {dialog.kind === "pulse" && <div className="pulse-details">
        <div><strong>1,086</strong><span>Active volunteers</span></div><div><strong>104</strong><span>New this month</span></div><div><strong>58</strong><span>Inactive</span></div>
        <p>Engagement improved by 12% compared with September, led by Environment and Safety programs.</p>
        <button className="primary-btn full-btn" onClick={() => complete("pulse", "Volunteer pulse summary downloaded.")}><Icon name="download" /> Download summary</button>
      </div>}
      {isForm && <form className="workflow-form" onSubmit={submit}>
        {dialog.kind === "activity" && <><div className="field-row"><label><span>Activity name</span><input required placeholder="e.g. Campus tree planting" /></label><label><span>Category</span><select required defaultValue=""><option value="" disabled>Select category</option><option>Environment</option><option>Safety</option><option>Training</option><option>Community</option></select></label></div><div className="field-row"><label><span>Date</span><input required type="date" /></label><label><span>Start time</span><input required type="time" /></label></div><label><span>Venue</span><input required placeholder="CMU campus venue" /></label><label><span>Description</span><textarea required placeholder="Describe the activity and volunteer responsibilities" /></label></>}
        {dialog.kind === "volunteer" && <><div className="field-row"><label><span>First name</span><input required placeholder="First name" /></label><label><span>Last name</span><input required placeholder="Last name" /></label></div><label><span>CMU email</span><input required type="email" placeholder="name@cmu.edu.ph" /></label><label><span>College or unit</span><select required defaultValue=""><option value="" disabled>Select unit</option><option>College of Agriculture</option><option>College of Engineering</option><option>College of Forestry</option><option>College of Nursing</option></select></label></>}
        {dialog.kind === "incident" && <><div className="field-row"><label><span>Incident type</span><select required defaultValue=""><option value="" disabled>Select type</option><option>Medical</option><option>Safety hazard</option><option>Weather</option><option>Security</option></select></label><label><span>Severity</span><select required><option>Low</option><option>Moderate</option><option>High</option></select></label></div><label><span>Location</span><input required placeholder="Building, road, or landmark" /></label><label><span>What happened?</span><textarea required placeholder="Provide clear, factual details" /></label><label className="inline-check"><input type="checkbox" /><span>Include my current device location</span></label></>}
        {dialog.kind === "attendance" && <><label><span>Activity</span><select required defaultValue=""><option value="" disabled>Select activity</option>{activities.map((a) => <option key={a.title}>{a.title}</option>)}</select></label><div className="field-row"><label><span>Session type</span><select><option>Check-in</option><option>Check-out</option></select></label><label><span>QR validity</span><select><option>15 minutes</option><option>30 minutes</option><option>1 hour</option></select></label></div><div className="form-notice"><Icon name="shield" /> A unique, time-limited QR code will be generated.</div></>}
        {dialog.kind === "announcement" && <><label><span>Title</span><input required placeholder="Announcement title" /></label><label><span>Audience</span><select required><option>All active volunteers</option><option>Activity participants</option><option>Unit coordinators</option></select></label><label><span>Message</span><textarea required placeholder="Write a clear message" /></label><label className="inline-check"><input type="checkbox" /><span>Send as a priority notification</span></label></>}
        {dialog.kind === "report" && <><label><span>Report type</span><select required><option>Volunteer impact summary</option><option>Attendance records</option><option>Service hours by unit</option><option>Activity participation</option></select></label><div className="field-row"><label><span>From</span><input required type="date" /></label><label><span>To</span><input required type="date" /></label></div><label><span>Format</span><select><option>CSV spreadsheet</option><option>Printable summary</option></select></label></>}
        {dialog.kind === "settings" && <><div className="setting-toggle"><span><b>Email notifications</b><small>Activity and announcement updates</small></span><input type="checkbox" defaultChecked /></div><div className="setting-toggle"><span><b>Emergency alerts</b><small>ODRRM safety advisories</small></span><input type="checkbox" defaultChecked /></div><label><span>Default workspace view</span><select><option>Overview</option><option>Activities</option><option>Reports</option></select></label></>}
        {dialog.kind === "profile" && <><label><span>Display name</span><input required defaultValue={dialog.title} /></label><label><span>Email address</span><input required type="email" defaultValue={dialog.title === "Alex Torres" ? "alex.torres@cmu.edu.ph" : `${dialog.title.toLowerCase().replace(" ", ".")}@student.cmu.edu.ph`} /></label><label><span>Role</span><input value={dialog.title === "Alex Torres" ? "SBNU Coordinator" : "Active volunteer"} readOnly /></label></>}
        <div className="form-actions"><button type="button" className="secondary-btn" onClick={close}>Cancel</button><button className="primary-btn" type="submit">{dialog.kind === "report" ? <><Icon name="download" /> Generate report</> : dialog.kind === "incident" ? "Submit securely" : dialog.kind === "settings" || dialog.kind === "profile" ? "Save changes" : "Create & save"}</button></div>
      </form>}
    </div>
  </div>;
}
