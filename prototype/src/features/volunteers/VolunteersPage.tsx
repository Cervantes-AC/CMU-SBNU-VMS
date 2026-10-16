import { useState } from "react";
import Icon from "../../shared/ui/Icon";
import type { OpenDialog } from "../../shared/types";
import { volunteers } from "./data";

export default function Volunteers({ onDialog }: { onDialog: OpenDialog }) {
  const [query, setQuery] = useState("");
  const [college, setCollege] = useState("All colleges");
  const allVolunteers = [...volunteers, { initials: "AS", name: "Aira Santos", unit: "College of Arts & Sciences", hours: 21, color: "#765341" }, { initials: "DN", name: "Daniel Navarro", unit: "College of Agriculture", hours: 18, color: "#566231" }];
  const collegeOptions = ["All colleges", "College of Forestry", "College of Engineering", "College of Nursing"];
  const shown = allVolunteers.filter((v) => (college === "All colleges" || v.unit === college) && `${v.name} ${v.unit}`.toLowerCase().includes(query.toLowerCase()));
  return <section className="subpage">
    <div className="subpage-hero"><div><span className="kicker">People directory</span><h2>1,248 people. One shared purpose.</h2><p>Manage member profiles, unit affiliations, service history, and volunteer standing.</p></div><button className="primary-btn" onClick={() => onDialog("volunteer", "Add a volunteer", "Create a member profile and assign their CMU college or unit.")}><span>+</span> Add volunteer</button></div>
    <div className="directory panel">
      <div className="directory-tools"><label className="search"><Icon name="search" /><input value={query} onChange={(e) => setQuery(e.target.value)} placeholder="Search volunteers..." /></label><button onClick={() => setCollege(collegeOptions[(collegeOptions.indexOf(college) + 1) % collegeOptions.length])}>{college} <Icon name="chevron" /></button><button onClick={() => onDialog("report", "Volunteer status filter", "All displayed volunteers currently have active status.")}>Active status <Icon name="chevron" /></button></div>
      <div className="table-head"><span>Volunteer</span><span>College / Unit</span><span>Service hours</span><span>Status</span><span>Last active</span></div>
      {shown.map((v, i) => <button className="table-row" onClick={() => onDialog("profile", v.name, `${v.unit} volunteer with ${v.hours} recorded service hours.`)} key={v.name}><span className="person"><i style={{ background: v.color }}>{v.initials}</i><b>{v.name}<small>{i % 2 ? "2026-04" : "2026-02"}{184 + i}</small></b></span><span>{v.unit}</span><strong>{v.hours} hrs</strong><span><b className="active-pill">Active</b></span><span>{i + 1} day{i ? "s" : ""} ago <Icon name="chevron" /></span></button>)}
      {!shown.length && <div className="empty-state">No volunteers match your search and college filters.</div>}
    </div>
  </section>;
}
