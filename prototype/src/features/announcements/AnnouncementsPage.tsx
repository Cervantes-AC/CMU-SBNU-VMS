import FeatureWorkspacePage from "../../shared/ui/FeatureWorkspacePage";
import type { OpenDialog } from "../../shared/types";

export default function AnnouncementsPage({ onDialog }: { onDialog: OpenDialog }) {
  return <FeatureWorkspacePage name="Announcements" eyebrow="Communications center" title="Keep every volunteer in the loop." description="Create targeted updates, safety notices, and program announcements for your community." icon="bell" dialogKind="announcement" dialogTitle="Create an announcement" dialogDescription="Publish a targeted message to an approved volunteer audience." actionLabel="announcement" onDialog={onDialog} />;
}
