import FeatureWorkspacePage from "../../shared/ui/FeatureWorkspacePage";
import type { OpenDialog } from "../../shared/types";

export default function ReportsPage({ onDialog }: { onDialog: OpenDialog }) {
  return <FeatureWorkspacePage name="Reports" eyebrow="Insights & analytics" title="Turn service into visible impact." description="Review participation, attendance, service hours, and unit performance across CMU." icon="report" dialogKind="report" dialogTitle="Generate a report" dialogDescription="Select a date range and report format for export." actionLabel="report" onDialog={onDialog} />;
}
