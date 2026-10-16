import type { IconName } from "../../shared/ui/Icon";

export const navItems = [
  { label: "Overview", icon: "dashboard" as IconName },
  { label: "Activities", icon: "calendar" as IconName, count: 8 },
  { label: "Volunteers", icon: "people" as IconName },
  { label: "Attendance", icon: "qr" as IconName },
  { label: "Announcements", icon: "bell" as IconName },
  { label: "Emergency", icon: "shield" as IconName, count: 2 },
  { label: "Reports", icon: "report" as IconName },
];
