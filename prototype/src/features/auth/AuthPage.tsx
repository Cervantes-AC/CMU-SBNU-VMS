import { useState } from "react";
import Icon from "../../shared/ui/Icon";
import type { AppScreen } from "../../shared/types";
import RegistrationForm from "./RegistrationForm";

export default function AuthPage({ mode, onMode, onSuccess }: { mode: "signin" | "signup" | "forgot"; onMode: (screen: AppScreen) => void; onSuccess: () => void }) {
  const [showPassword, setShowPassword] = useState(false);
  const [submitted, setSubmitted] = useState(false);
  const submit = (e: React.FormEvent) => {
    e.preventDefault();
    if (mode === "forgot") setSubmitted(true);
    else onSuccess();
  };
  return <div className={`auth-page ${mode === "signup" ? "registration-mode" : ""}`}>
    <div className="auth-aside">
      <button className="auth-back" onClick={() => onMode("landing")}><Icon name="arrow" /> Back to home</button>
      <div className="auth-story"><div className="auth-main-logo"><img src="/brand/sbnu.svg" alt="SBNu logo" /></div><span className="landing-eyebrow"><b>CMU Volunteer Corps</b></span><h1>Purpose brings us<br/>together.</h1><p>Join a university-wide network turning service, compassion, and preparedness into meaningful community impact.</p></div>
      <div className="auth-quote"><Icon name="heart" /><blockquote>“The smallest act of service becomes powerful when a community moves as one.”</blockquote><span>SBNu Volunteer Network</span></div>
      <div className="auth-partners"><img src="/brand/cmu.svg" alt="CMU" /><span>Central Mindanao University</span><i /><img src="/brand/odrrm.svg" alt="ODRRM" /><span>ODRRM</span></div>
    </div>
    <main className="auth-main">
      <div className={`auth-card ${mode === "signup" ? "registration-card" : ""}`}>
        <button className="auth-mobile-back" onClick={() => onMode("landing")}><Icon name="arrow" /> Home</button>
        {mode === "signup" ? <RegistrationForm onSignIn={() => onMode("signin")} /> : mode === "forgot" && submitted ? <div className="auth-success"><span><Icon name="check" /></span><h2>Check your inbox</h2><p>If a CMU account matches that email, we sent password recovery instructions.</p><button onClick={() => onMode("signin")}>Return to sign in</button></div> : <>
          <div className="auth-heading"><span>{mode === "signin" ? "Welcome back" : mode === "signup" ? "Join the network" : "Account recovery"}</span><h2>{mode === "signin" ? "Sign in to SBNu" : mode === "signup" ? "Create your account" : "Reset your password"}</h2><p>{mode === "signin" ? "Access your volunteer workspace and continue making an impact." : mode === "signup" ? "Use your CMU email to begin your volunteer journey." : "Enter your registered CMU email and we’ll send recovery instructions."}</p></div>
          <form className="auth-form" onSubmit={submit}>
            {mode === "signup" && <div className="field-row"><label><span>First name</span><input required placeholder="Alex" /></label><label><span>Last name</span><input required placeholder="Torres" /></label></div>}
            <label><span>CMU email address</span><div className="auth-input"><input required type="email" placeholder="name@cmu.edu.ph" /><Icon name="people" /></div></label>
            {mode !== "forgot" && <label><span>Password</span><div className="auth-input"><input required minLength={8} type={showPassword ? "text" : "password"} placeholder="At least 8 characters" /><button type="button" onClick={() => setShowPassword(!showPassword)}>{showPassword ? "Hide" : "Show"}</button></div></label>}
            {mode === "signup" && <label><span>College or unit</span><select required defaultValue=""><option value="" disabled>Select your college or unit</option><option>College of Agriculture</option><option>College of Arts & Sciences</option><option>College of Engineering</option><option>College of Forestry</option><option>College of Nursing</option></select></label>}
            {mode === "signin" && <div className="auth-options"><label><input type="checkbox" /><span>Keep me signed in</span></label><button type="button" onClick={() => onMode("forgot")}>Forgot password?</button></div>}
            {mode === "signup" && <label className="terms-check"><input required type="checkbox" /><span>I agree to the volunteer code of conduct and acknowledge the CMU privacy notice.</span></label>}
            <button className="auth-submit" type="submit">{mode === "signin" ? "Sign in to workspace" : mode === "signup" ? "Create volunteer account" : "Send recovery link"} <Icon name="arrow" /></button>
          </form>
          {mode !== "forgot" && <p className="auth-switch">{mode === "signin" ? "New to the volunteer network?" : "Already have an account?"} <button onClick={() => onMode(mode === "signin" ? "signup" : "signin")}>{mode === "signin" ? "Create an account" : "Sign in"}</button></p>}
          {mode === "forgot" && <p className="auth-switch">Remembered your password? <button onClick={() => onMode("signin")}>Sign in</button></p>}
          <div className="auth-security"><Icon name="shield" /><span>Protected by CMU account security and privacy controls.</span></div>
        </>}
      </div>
    </main>
  </div>;
}
