import { useState } from "react";
import Icon from "../../shared/ui/Icon";
import type { OpenDialog } from "../../shared/types";
import { activities } from "./data";

export default function Activities({ onDialog, notify }: { onDialog: OpenDialog; notify: (message: string) => void }) {
  const [joined, setJoined] = useState<string[]>([]);
  const [filter, setFilter] = useState("All activities");
  const filters = ["All activities", "Environment", "Safety", "Training", "Community"];
  const visible = filter === "All activities" ? activities : activities.filter((_, index) => ({ Safety: 0, Environment: 1, Training: 2, Community: 1 }[filter] === index));
  return <section className="subpage">
    <div className="subpage-hero"><div><span className="kicker">Discover & participate</span><h2>Build community through action.</h2><p>Explore upcoming programs, reserve your place, and track the difference you make.</p></div><button className="primary-btn" onClick={() => onDialog("activity", "Create a new activity", "Add the schedule, venue, category, and volunteer capacity.")}><span>+</span> New activity</button></div>
    <div className="filter-row">{filters.map((item) => <button key={item} className={filter === item ? "selected" : ""} onClick={() => setFilter(item)}>{item} {item === "All activities" && <b>24</b>}</button>)}</div>
    <div className="activity-cards">
      {visible.map((a) => {
        const index = activities.indexOf(a);
        return <article className="activity-card" key={a.title}>
        <div className={`card-visual visual-${index}`}><span>{index === 0 ? "Safety & preparedness" : index === 1 ? "Environment" : "Skills training"}</span><div className="giant-number">{a.date}</div><small>{a.month} · 2026</small></div>
        <div className="card-body"><h3>{a.title}</h3><p><Icon name="pin" />{a.meta}</p><p><Icon name="clock" />{a.time}</p><div className="capacity"><span><b>{a.people}</b> volunteers joined</span><span>{a.progress}% full</span></div><div className="capacity-bar"><i style={{ width: `${a.progress}%` }} /></div><button className={joined.includes(a.title) ? "joined" : ""} onClick={() => { const isJoined = joined.includes(a.title); setJoined((old) => isJoined ? old.filter((x) => x !== a.title) : [...old, a.title]); notify(isJoined ? "You left this activity." : "You successfully joined the activity."); }}>{joined.includes(a.title) ? <><Icon name="check" /> You're joining</> : <>View & join <Icon name="arrow" /></>}</button></div>
      </article>;
      })}
    </div>
  </section>;
}
