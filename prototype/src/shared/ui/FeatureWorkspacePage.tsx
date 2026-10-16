import Icon from "./Icon";
import type { IconName } from "./Icon";
import type { DialogKind, OpenDialog } from "../types";

type FeatureWorkspacePageProps = {
  name: string;
  eyebrow: string;
  title: string;
  description: string;
  icon: IconName;
  dialogKind: DialogKind;
  dialogTitle: string;
  dialogDescription: string;
  actionLabel: string;
  onDialog: OpenDialog;
};

export default function FeatureWorkspacePage({ name, eyebrow, title, description, icon, dialogKind, dialogTitle, dialogDescription, actionLabel, onDialog }: FeatureWorkspacePageProps) {
  const open = () => onDialog(dialogKind, dialogTitle, dialogDescription);
  return <section className="subpage">
    <div className="subpage-hero"><div><span className="kicker">{eyebrow}</span><h2>{title}</h2><p>{description}</p></div><button className="primary-btn" onClick={open}><Icon name={icon} /> New {actionLabel}</button></div>
    <div className="generic-grid">
      <div className="panel chart-card"><div className="panel-head"><div><span className="kicker">Last 6 months</span><h3>{name} overview</h3></div><span className="period">Monthly</span></div><div className="bars">{[42, 58, 49, 76, 64, 88, 72, 96, 82, 100, 91, 112].map((value, index) => <i key={index} style={{ height: `${value}px` }} />)}</div><div className="chart-labels"><span>May</span><span>Jun</span><span>Jul</span><span>Aug</span><span>Sep</span><span>Oct</span></div></div>
      <div className="panel quick-card"><span className="kicker">Quick action</span><Icon name={icon} /><h3>Ready when you are</h3><p>Create and manage {name.toLowerCase()} from this dedicated workspace.</p><button className="primary-btn" onClick={open}>Get started <Icon name="arrow" /></button></div>
    </div>
  </section>;
}
