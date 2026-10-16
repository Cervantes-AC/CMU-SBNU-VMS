import { useState } from "react";
import Icon from "../../shared/ui/Icon";

export default function SOSModal({ close }: { close: () => void }) {
  const [sent, setSent] = useState(false);
  return <div className="modal-backdrop" onMouseDown={close}><div className="sos-modal" onMouseDown={(e) => e.stopPropagation()}>
    <button className="modal-close" onClick={close}><Icon name="x" /></button>
    {sent ? <div className="sent-state"><span><Icon name="check" /></span><h2>Request submitted</h2><p>Your alert reference is <b>SOS-1026-042</b>. Designated CMU responders have been notified. Keep your phone available.</p><button className="primary-btn" onClick={close}>Return to dashboard</button></div> : <><div className="sos-symbol"><Icon name="alert" /></div><span className="kicker">Urgent assistance</span><h2>Do you need help now?</h2><p>This sends your name, current time, and optional location to designated CMU campus responders.</p><label className="location-check"><input type="checkbox" defaultChecked /><span><b>Share my current location</b><small>Only for this alert</small></span></label><button className="send-sos" onClick={() => setSent(true)}>Confirm & send SOS</button><button className="cancel-sos" onClick={close}>Cancel</button><small className="modal-note">This does not contact public emergency services.</small></>}
  </div></div>;
}
