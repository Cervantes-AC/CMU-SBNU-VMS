import Icon from "../../shared/ui/Icon";
import type { OpenDialog } from "../../shared/types";
import { navItems } from "./navigation";

export default function Sidebar({ active, setActive, open, setOpen, onDialog, onLogout }: { active: string; setActive: (v: string) => void; open: boolean; setOpen: (v: boolean) => void; onDialog: OpenDialog; onLogout: () => void }) {
  return <aside className={`sidebar ${open ? "sidebar-open" : ""}`}>
    <button className="sidebar-close" onClick={() => setOpen(false)} aria-label="Close navigation"><Icon name="x" /></button>
    <div className="brand">
      <div className="brand-mark"><img src="/brand/sbnu.svg" alt="SBNu logo" /></div>
      <div><strong>SBNu</strong><span>Volunteer Corps</span></div>
    </div>
    <div className="university-label"><span>Central Mindanao University</span></div>
    <nav className="nav-list" aria-label="Main navigation">
      <p>Workspace</p>
      {navItems.map((item) => <button key={item.label} className={active === item.label ? "active" : ""} onClick={() => { setActive(item.label); setOpen(false); }}>
        <Icon name={item.icon} /><span>{item.label}</span>{item.count && <b>{item.count}</b>}
      </button>)}
    </nav>
    <div className="sidebar-bottom">
      <button onClick={() => onDialog("settings", "Workspace settings", "Manage notifications, privacy, appearance, and volunteer preferences.")}><Icon name="settings" /><span>Settings</span></button>
      <div className="office-card">
        <img src="/brand/odrrm.svg" alt="ODRRM logo" />
        <div><small>Partner office</small><strong>ODRRM</strong><span>Safety & resilience</span></div>
      </div>
      <button className="profile" onClick={() => onDialog("profile", "Alex Torres", "Review your coordinator profile and account information.")}>
        <div className="avatar">AT</div>
        <div><strong>Alex Torres</strong><span>SBNU Coordinator</span></div>
        <Icon name="chevron" />
      </button>
      <button className="logout-button" onClick={onLogout}><Icon name="arrow" /><span>Sign out</span></button>
    </div>
  </aside>;
}
