import FeatureWorkspacePage from "../../shared/ui/FeatureWorkspacePage";
import type { OpenDialog } from "../../shared/types";

export default function AttendancePage({ onDialog }: { onDialog: OpenDialog }) {
  return <FeatureWorkspacePage name="Attendance" eyebrow="QR-assisted records" title="Attendance, without the friction." description="Open a secure check-in session, validate participation, and review attendance records." icon="qr" dialogKind="attendance" dialogTitle="Open attendance session" dialogDescription="Create a time-limited QR check-in for an activity." actionLabel="session" onDialog={onDialog} />;
}
