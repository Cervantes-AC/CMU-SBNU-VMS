import { useState } from "react";
import Icon from "../../shared/ui/Icon";
import type { OpenDialog } from "../../shared/types";
import { navItems } from "./navigation";

export default function Header({ active, onMenu, onNavigate, onDialog }: { active: string; onMenu: () => void; onNavigate: (v: string) => void; onDialog: OpenDialog }) {
  const [query, setQuery] = useState("");
  const search = () => {
    const normalized = query.toLowerCase();
    const target = navItems.find((item) => item.label.toLowerCase().includes(normalized));
    if (target) onNavigate(target.label);
    else if (normalized.includes("sos") || normalized.includes("safety") || normalized.includes("incident")) onNavigate("Emergency");
    else if (query.trim()) onDialog("report", `Search results for “${query.trim()}”`, "No exact workspace match was found. Try activities, volunteers, attendance, announcements, emergency, or reports.");
  };
  return <header className="topbar">
    <div className="page-title">
      <button className="menu-button" onClick={onMenu} aria-label="Open navigation"><Icon name="menu" /></button>
      <div><span>SBNU / {active}</span><h1>{active}</h1></div>
    </div>
    <div className="top-actions">
      <label className="search"><Icon name="search" /><input value={query} onChange={(e) => setQuery(e.target.value)} onKeyDown={(e) => { if (e.key === "Enter") search(); }} placeholder="Search anything..." aria-label="Search" /><kbd onClick={search}>Enter</kbd></label>
      <button className="icon-button" onClick={() => onDialog("notifications", "Notifications", "Your latest volunteer network updates.")} aria-label="Notifications"><Icon name="bell" /><i /></button>
      <div className="cmu-lockup"><img src="/brand/cmu.svg" alt="Central Mindanao University logo" /><span>Central Mindanao<br/><strong>University</strong></span></div>
    </div>
  </header>;
}
