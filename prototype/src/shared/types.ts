export type DialogKind = "activity" | "volunteer" | "incident" | "map" | "hotlines" | "attendance" | "announcement" | "report" | "notifications" | "settings" | "profile" | "pulse";
export type DialogState = { kind: DialogKind; title: string; description: string } | null;
export type OpenDialog = (kind: DialogKind, title: string, description: string) => void;
export type AppScreen = "landing" | "signin" | "signup" | "forgot" | "dashboard";
