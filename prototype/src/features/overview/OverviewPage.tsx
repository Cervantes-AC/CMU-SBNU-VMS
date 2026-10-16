import Icon from "../../shared/ui/Icon";
import type { IconName } from "../../shared/ui/Icon";
import VolunteerActionGraphic from "../../shared/graphics/VolunteerActionGraphic";
import type { OpenDialog } from "../../shared/types";
import { activities } from "../activities/data";
import { volunteers } from "../volunteers/data";

function Metric({ icon, label, value, delta, color }: { icon: IconName; label: string; value: string; delta: string; color: string }) {
  return <div className="metric-card">
    <div className="metric-head"><span className={`metric-icon ${color}`}><Icon name={icon} /></span><span className="delta"><Icon name="trend" />{delta}</span></div>
    <strong>{value}</strong><span>{label}</span>
    <div className="metric-line"><i style={{ width: `${Math.min(92, Number.parseInt(delta) * 6 + 32)}%` }} /></div>
  </div>;
}

export default function Overview({ onNavigate, onSOS, onDialog, onExport }: { onNavigate: (v: string) => void; onSOS: () => void; onDialog: OpenDialog; onExport: () => void }) {
  return <>
    <section className="welcome">
      <div>
        <div className="eyebrow"><span /><b>Tuesday, October 20</b><i>Academic Year 2026–2027</i></div>
        <h2>Good morning, Alex.</h2>
        <p>Here’s what’s happening across the volunteer network today.</p>
      </div>
      <div className="welcome-actions">
        <button className="secondary-btn" onClick={onExport}><Icon name="download" /> Export report</button>
        <button className="primary-btn" onClick={() => onDialog("activity", "Create a new activity", "Add the schedule, venue, category, and volunteer capacity.")}><span>+</span> Create activity</button>
      </div>
    </section>
    <section className="metric-grid">
      <Metric icon="people" label="Active volunteers" value="1,248" delta="12%" color="green" />
      <Metric icon="calendar" label="Active activities" value="24" delta="8%" color="gold" />
      <Metric icon="clock" label="Service hours" value="3,892" delta="16%" color="blue" />
      <Metric icon="check" label="Attendance rate" value="87.4%" delta="4%" color="purple" />
    </section>
    <section className="dashboard-grid">
      <div className="panel activity-panel">
        <div className="panel-head"><div><span className="kicker">Schedule</span><h3>Upcoming activities</h3></div><button onClick={() => onNavigate("Activities")}>View all <Icon name="arrow" /></button></div>
        <div className="activity-list">
          {activities.map((activity) => <button className="activity-row" key={activity.title} onClick={() => onNavigate("Activities")}>
            <div className={`date-tile ${activity.color}`}><strong>{activity.date}</strong><span>{activity.month}</span></div>
            <div className="activity-info"><strong>{activity.title}</strong><span><Icon name="pin" />{activity.meta}<i /> <Icon name="clock" />{activity.time}</span></div>
            <div className="activity-people"><div className="mini-avatars"><i>LA</i><i>JM</i><i>RK</i></div><span>{activity.people} joined</span></div>
            <Icon name="chevron" className="row-arrow" />
          </button>)}
        </div>
      </div>
      <div className="panel pulse-panel">
        <div className="panel-head"><div><span className="kicker">This month</span><h3>Volunteer pulse</h3></div><button className="more-btn" onClick={() => onDialog("pulse", "Volunteer pulse details", "A summary of active, new, and inactive volunteers for October.")}>•••</button></div>
        <div className="donut-wrap">
          <div className="donut"><div><strong>87%</strong><span>engaged</span></div></div>
          <div className="legend">
            <div><i className="legend-green" /><span>Active</span><strong>1,086</strong></div>
            <div><i className="legend-gold" /><span>New</span><strong>104</strong></div>
            <div><i className="legend-gray" /><span>Inactive</span><strong>58</strong></div>
          </div>
        </div>
        <div className="pulse-foot"><span><Icon name="spark" /> <b>124</b> new this month</span><small>Top 10% among CMU units</small></div>
      </div>
      <div className="panel impact-panel">
        <div className="impact-copy"><span className="kicker light">Collective impact</span><h3>Small actions.<br/>Lasting change.</h3><p>SBNU volunteers have served <b>38,420 hours</b> since 2022.</p><button onClick={() => onNavigate("Reports")}>Explore our impact <Icon name="arrow" /></button></div>
        <div className="impact-art"><div className="ring one"/><div className="ring two"/><VolunteerActionGraphic compact /></div>
      </div>
      <div className="panel leaders-panel">
        <div className="panel-head"><div><span className="kicker">Community</span><h3>Top volunteers</h3></div><span className="period">October</span></div>
        <div className="leader-list">
          {volunteers.map((volunteer, index) => <div className="leader" key={volunteer.name}><span className="rank">0{index + 1}</span><i style={{ background: volunteer.color }}>{volunteer.initials}</i><div><strong>{volunteer.name}</strong><span>{volunteer.unit}</span></div><b>{volunteer.hours}<small> hrs</small></b></div>)}
        </div>
      </div>
      <div className="panel safety-panel">
        <div className="safety-head"><div className="odrrm-mini"><img src="/brand/odrrm.svg" alt="ODRRM" /></div><div><span className="kicker">ODRRM Safety Center</span><h3>Campus status</h3></div><span className="status-safe"><i /> Normal</span></div>
        <p>No active emergency advisories. Safety teams and verified hotlines are standing by.</p>
        <div className="safety-actions"><button onClick={() => onNavigate("Emergency")}><Icon name="shield" /> Open safety center</button><button className="sos-small" onClick={onSOS}><Icon name="alert" /> SOS</button></div>
      </div>
    </section>
  </>;
}
