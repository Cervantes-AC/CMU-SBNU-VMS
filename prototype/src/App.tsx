import { useMemo, useState } from "react";
import LandingPage from "./features/landing/LandingPage";
import AuthPage from "./features/auth/AuthPage";
import Sidebar from "./features/dashboard/Sidebar";
import Header from "./features/dashboard/Header";
import ActionDialog from "./features/dashboard/ActionDialog";
import OverviewPage from "./features/overview/OverviewPage";
import ActivitiesPage from "./features/activities/ActivitiesPage";
import VolunteersPage from "./features/volunteers/VolunteersPage";
import EmergencyPage from "./features/emergency/EmergencyPage";
import SOSModal from "./features/emergency/SOSModal";
import AttendancePage from "./features/attendance/AttendancePage";
import AnnouncementsPage from "./features/announcements/AnnouncementsPage";
import ReportsPage from "./features/reports/ReportsPage";
import Icon from "./shared/ui/Icon";
import type { AppScreen, DialogKind, DialogState, OpenDialog } from "./shared/types";

export default function App() {
  const [screen, setScreen] = useState<AppScreen>("landing");
  const [active, setActive] = useState("Overview");
  const [navOpen, setNavOpen] = useState(false);
  const [sosOpen, setSOSOpen] = useState(false);
  const [dialog, setDialog] = useState<DialogState>(null);
  const [toast, setToast] = useState("");
  const notify = (message: string) => {
    setToast(message);
    window.setTimeout(() => setToast(""), 3200);
  };
  const openDialog: OpenDialog = (kind, title, description) => setDialog({ kind, title, description });
  const downloadReport = (message = "Impact report downloaded.") => {
    const csv = "Metric,Value\nActive volunteers,1248\nActive activities,24\nService hours,3892\nAttendance rate,87.4%\n";
    const url = URL.createObjectURL(new Blob([csv], { type: "text/csv" }));
    const anchor = document.createElement("a");
    anchor.href = url;
    anchor.download = "cmu-sbnu-impact-report.csv";
    anchor.click();
    URL.revokeObjectURL(url);
    notify(message);
  };
  const completeDialog = (kind: DialogKind, message: string) => {
    if (kind === "report" || kind === "pulse") downloadReport(message);
    else notify(message);
    setDialog(null);
  };
  const content = useMemo(() => {
    if (active === "Overview") return <OverviewPage onNavigate={setActive} onSOS={() => setSOSOpen(true)} onDialog={openDialog} onExport={() => downloadReport()} />;
    if (active === "Activities") return <ActivitiesPage onDialog={openDialog} notify={notify} />;
    if (active === "Volunteers") return <VolunteersPage onDialog={openDialog} />;
    if (active === "Emergency") return <EmergencyPage onSOS={() => setSOSOpen(true)} onDialog={openDialog} />;
    if (active === "Attendance") return <AttendancePage onDialog={openDialog} />;
    if (active === "Announcements") return <AnnouncementsPage onDialog={openDialog} />;
    return <ReportsPage onDialog={openDialog} />;
  }, [active]);

  if (screen === "landing") return <LandingPage onAuth={setScreen} />;
  if (screen === "signin" || screen === "signup" || screen === "forgot") return <AuthPage mode={screen} onMode={setScreen} onSuccess={() => setScreen("dashboard")} />;

  return <div className="app-shell">
    <Sidebar active={active} setActive={setActive} open={navOpen} setOpen={setNavOpen} onDialog={openDialog} onLogout={() => { setActive("Overview"); setScreen("landing"); }} />
    {navOpen && <button className="nav-backdrop" onClick={() => setNavOpen(false)} aria-label="Close navigation" />}
    <main className="main">
      <Header active={active} onMenu={() => setNavOpen(true)} onNavigate={setActive} onDialog={openDialog} />
      <div className="content">{content}</div>
      <footer><span>CMU SBNu Volunteer Management System</span><span>Service • Bayanihan • Nationalism • Unity</span></footer>
    </main>
    {sosOpen && <SOSModal close={() => setSOSOpen(false)} />}
    {dialog && <ActionDialog dialog={dialog} close={() => setDialog(null)} complete={completeDialog} />}
    {toast && <div className="toast"><span><Icon name="check" /></span>{toast}</div>}
  </div>;
}
