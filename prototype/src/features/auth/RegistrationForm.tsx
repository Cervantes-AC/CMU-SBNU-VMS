import { useEffect, useMemo, useRef, useState } from "react";
import Icon from "../../shared/ui/Icon";
import { cmuAcademics, competencies, registrationSteps, yearLevels } from "./registration-data";

type RegistrationDraft = Record<string, string>;

export default function RegistrationForm({ onSignIn }: { onSignIn: () => void }) {
  const restoredDraft = useMemo(() => {
    try { return JSON.parse(localStorage.getItem("sbnu_registration_draft") || "{}") as RegistrationDraft; } catch { return {}; }
  }, []);
  const [step, setStep] = useState(0);
  const [data, setData] = useState<RegistrationDraft>(restoredDraft);
  const [password, setPassword] = useState("");
  const [password2, setPassword2] = useState("");
  const [showPassword, setShowPassword] = useState(false);
  const [showPassword2, setShowPassword2] = useState(false);
  const [consents, setConsents] = useState([false, false, false, false, false]);
  const [error, setError] = useState("");
  const [done, setDone] = useState(false);
  const [restored, setRestored] = useState(Object.keys(restoredDraft).length > 0);
  const formRef = useRef<HTMLFormElement>(null);
  const update = (field: string, value: string) => setData((old) => ({ ...old, [field]: value }));

  useEffect(() => {
    const timeout = window.setTimeout(() => localStorage.setItem("sbnu_registration_draft", JSON.stringify(data)), 250);
    return () => window.clearTimeout(timeout);
  }, [data]);

  const next = (e: React.FormEvent) => {
    e.preventDefault();
    setError("");
    if (step === 0 && password !== password2) { setError("Passwords do not match. Please check both entries."); return; }
    if (step === 2 && (!data.college || !data.program || !data.yearLevel || !data.competency || !data.contact)) { setError("Complete all academic and competency fields before continuing."); return; }
    if (step < 4) { setStep((old) => old + 1); window.scrollTo({ top: 0, behavior: "smooth" }); }
  };
  const submit = (e: React.FormEvent) => {
    e.preventDefault();
    if (!consents.every(Boolean)) { setError("Please acknowledge all five privacy statements to create your account."); return; }
    localStorage.removeItem("sbnu_registration_draft");
    setDone(true);
  };
  const clearDraft = () => {
    localStorage.removeItem("sbnu_registration_draft");
    setData({});
    setPassword("");
    setPassword2("");
    setRestored(false);
  };

  if (done) return <div className="registration-success">
    <span><Icon name="check" /></span><h2>Registration submitted</h2><p>Your volunteer application is now pending review by an authorized SBNu coordinator. You’ll receive an update through your CMU email after verification.</p>
    <div className="pending-badge"><i /> Pending account approval</div><button onClick={onSignIn}>Back to sign in <Icon name="arrow" /></button>
  </div>;

  const stepContent = [
    <div className="register-fields" key="account">
      <label><span>CMU email address</span><div className="auth-input"><input required type="email" value={data.email || ""} onChange={(e) => update("email", e.target.value)} placeholder="name@cmu.edu.ph" /><Icon name="people" /></div><small>Use your active institutional email.</small></label>
      <label><span>Create password</span><div className="auth-input"><input required minLength={8} type={showPassword ? "text" : "password"} value={password} onChange={(e) => setPassword(e.target.value)} placeholder="At least 8 characters" /><button type="button" onClick={() => setShowPassword(!showPassword)}>{showPassword ? "Hide" : "Show"}</button></div></label>
      <label><span>Confirm password</span><div className="auth-input"><input required minLength={8} type={showPassword2 ? "text" : "password"} value={password2} onChange={(e) => setPassword2(e.target.value)} placeholder="Enter password again" /><button type="button" onClick={() => setShowPassword2(!showPassword2)}>{showPassword2 ? "Hide" : "Show"}</button></div></label>
      <div className="password-guide"><Icon name="shield" /><span><b>Keep your account secure</b><small>Use at least 8 characters with a mix of letters and numbers.</small></span></div>
    </div>,
    <div className="register-fields" key="personal">
      <label><span>Full name</span><input required value={data.name || ""} onChange={(e) => update("name", e.target.value)} placeholder="Full legal name" /></label>
      <div className="field-row"><label><span>Student ID</span><input required value={data.studentId || ""} onChange={(e) => update("studentId", e.target.value)} placeholder="2026-00000" /></label><label><span>Serial number</span><input required value={data.serial || ""} onChange={(e) => update("serial", e.target.value)} placeholder="CMU serial number" /></label></div>
      <div className="field-row"><label><span>Birthdate</span><input required type="date" max={new Date(new Date().setFullYear(new Date().getFullYear() - 10)).toISOString().split("T")[0]} value={data.birthdate || ""} onChange={(e) => update("birthdate", e.target.value)} /></label><label><span>Gender</span><select required value={data.gender || "Male"} onChange={(e) => update("gender", e.target.value)}><option>Male</option><option>Female</option><option>Prefer not to say</option></select></label></div>
    </div>,
    <div className="register-fields" key="academic">
      <label><span>College</span><select required value={data.college || ""} onChange={(e) => setData((old) => ({ ...old, college: e.target.value, program: "" }))}><option value="" disabled>Select your college</option>{Object.keys(cmuAcademics).map((college) => <option key={college}>{college}</option>)}</select></label>
      <label><span>Program / Major</span><select required disabled={!data.college} value={data.program || ""} onChange={(e) => update("program", e.target.value)}><option value="" disabled>{data.college ? "Select your program" : "Select a college first"}</option>{(cmuAcademics[data.college] || []).map((program) => <option key={program}>{program}</option>)}</select></label>
      <div className="field-row"><label><span>Year level</span><select required value={data.yearLevel || ""} onChange={(e) => update("yearLevel", e.target.value)}><option value="" disabled>Select year</option>{yearLevels.map((year) => <option key={year}>{year}</option>)}</select></label><label><span>Contact number</span><input required type="tel" value={data.contact || ""} onChange={(e) => update("contact", e.target.value)} placeholder="09XX XXX XXXX" /></label></div>
      <label><span>Primary NSRC competency</span><select required value={data.competency || ""} onChange={(e) => update("competency", e.target.value)}><option value="" disabled>Select your primary competency</option>{competencies.map((competency) => <option key={competency}>{competency}</option>)}</select></label>
    </div>,
    <div className="register-fields" key="address">
      <label><span>Current address</span><textarea required value={data.currAddr || ""} onChange={(e) => update("currAddr", e.target.value)} placeholder="Current residence, barangay, city or municipality" /></label>
      <label><span>Permanent home address <i>Optional</i></span><textarea value={data.homeAddr || ""} onChange={(e) => update("homeAddr", e.target.value)} placeholder="Leave blank if the same as current address" /></label>
      <div className="register-divider"><span>Emergency contact</span></div>
      <div className="field-row"><label><span>Contact person <i>Optional</i></span><input value={data.ecName || ""} onChange={(e) => update("ecName", e.target.value)} placeholder="Full name" /></label><label><span>Contact number <i>Optional</i></span><input type="tel" value={data.ecNumber || ""} onChange={(e) => update("ecNumber", e.target.value)} placeholder="09XX XXX XXXX" /></label></div>
    </div>,
    <div className="privacy-step" key="privacy">
      <div className="privacy-intro"><Icon name="shield" /><div><h3>Your information, handled responsibly.</h3><p>Review and acknowledge each statement before submitting your registration.</p></div></div>
      {[
        ["Collection and use", "I consent to CMU–SBNu collecting the information in this form for volunteer administration and approved institutional purposes."],
        ["Profile verification", "I understand that my student and academic information may be verified by authorized CMU personnel."],
        ["Emergency information", "I consent to authorized personnel using my emergency information only when reasonably necessary for safety and response."],
        ["Privacy and access", "I understand that access is role-based and my information will be handled according to CMU privacy policies."],
        ["Accuracy and conduct", "I confirm that the information provided is accurate and agree to the SBNu volunteer code of conduct."],
      ].map(([title, body], index) => <label className={consents[index] ? "consent checked" : "consent"} key={title}><input type="checkbox" checked={consents[index]} onChange={() => setConsents((old) => old.map((value, i) => i === index ? !value : value))} /><span><b>{title}</b><small>{body}</small></span><Icon name="check" /></label>)}
      <div className="consent-progress"><span>{consents.filter(Boolean).length} of 5 acknowledged</span><div><i style={{ width: `${consents.filter(Boolean).length * 20}%` }} /></div></div>
    </div>,
  ][step];

  return <div className="registration-form">
    <div className="registration-head"><span>Create account</span><h2>Join the SBNu network</h2><p>Step {step + 1} of 5 — <b>{registrationSteps[step].title}</b></p></div>
    <div className="step-progress">{registrationSteps.map((item, index) => <button type="button" key={item.title} onClick={() => index < step && setStep(index)} className={index === step ? "current" : index < step ? "complete" : ""}><i style={{ background: index <= step ? item.color : undefined }}>{index < step ? <Icon name="check" /> : index + 1}</i><span>{item.title}</span></button>)}</div>
    {restored && <div className="draft-banner"><Icon name="clock" /><span><b>Draft restored</b><small>We recovered your saved registration details.</small></span><button type="button" onClick={clearDraft}>Start over</button></div>}
    {error && <div className="registration-error"><Icon name="alert" />{error}</div>}
    <form className="registration-step-form auth-form" ref={formRef} onSubmit={step === 4 ? submit : next}>
      {stepContent}
      <div className="registration-nav">{step > 0 && <button type="button" onClick={() => { setStep((old) => old - 1); setError(""); }}><Icon name="arrow" /> Back</button>}<button style={{ background: registrationSteps[step].color }} type="submit">{step < 4 ? <>Continue <Icon name="arrow" /></> : <>Create account <Icon name="check" /></>}</button></div>
    </form>
    <p className="auth-switch">Already have an account? <button type="button" onClick={onSignIn}>Sign in</button></p>
  </div>;
}
