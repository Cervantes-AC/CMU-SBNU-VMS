import Icon from "../../shared/ui/Icon";
import VolunteerActionGraphic from "../../shared/graphics/VolunteerActionGraphic";
import type { AppScreen } from "../../shared/types";

function PublicHeader({ onAuth }: { onAuth: (screen: AppScreen) => void }) {
  const scrollTo = (id: string) => document.getElementById(id)?.scrollIntoView({ behavior: "smooth" });
  return <header className="public-header">
    <button className="public-brand" onClick={() => window.scrollTo({ top: 0, behavior: "smooth" })}>
      <img src="/brand/sbnu.svg" alt="SBNu logo" />
      <span><strong>SBNu</strong><small>CMU Volunteer Corps</small></span>
    </button>
    <nav aria-label="Public navigation">
      <button onClick={() => scrollTo("mission")}>Mission</button>
      <button onClick={() => scrollTo("programs")}>Programs</button>
      <button onClick={() => scrollTo("impact")}>Impact</button>
      <button onClick={() => scrollTo("safety")}>Safety</button>
    </nav>
    <div className="public-actions"><button onClick={() => onAuth("signin")}>Sign in</button><button onClick={() => onAuth("signup")}>Join the network <Icon name="arrow" /></button></div>
  </header>;
}

export default function LandingPage({ onAuth }: { onAuth: (screen: AppScreen) => void }) {
  return <div className="landing-page">
    <PublicHeader onAuth={onAuth} />
    <main>
      <section className="landing-hero">
        <div className="hero-copy">
          <div className="landing-eyebrow"><span /><b>Central Mindanao University</b><i>Volunteer Management System</i></div>
          <h1>Service that moves<br/>a community <em>forward.</em></h1>
          <p>One connected space for CMU volunteers to discover opportunities, serve with purpose, and build a safer, more resilient community.</p>
          <div className="hero-actions"><button onClick={() => onAuth("signup")}>Become a volunteer <Icon name="arrow" /></button><button onClick={() => document.getElementById("programs")?.scrollIntoView({ behavior: "smooth" })}>Explore programs</button></div>
          <div className="hero-trust"><div className="hero-avatars"><i>MA</i><i>JR</i><i>CL</i><i>+</i></div><span><b>1,248 active volunteers</b><small>Serving across the CMU community</small></span></div>
        </div>
        <div className="hero-visual">
          <div className="hero-orbit orbit-one" /><div className="hero-orbit orbit-two" />
          <div className="hero-shield"><VolunteerActionGraphic /></div>
          <div className="floating-card float-hours"><Icon name="clock" /><span><b>38,420</b><small>Service hours since 2022</small></span></div>
          <div className="floating-card float-impact"><span><b>87%</b><small>Volunteer engagement</small></span><div><i style={{ width: "87%" }} /></div></div>
          <div className="hero-seal"><img src="/brand/cmu.svg" alt="Central Mindanao University" /><span>Rooted in<br/><b>Excellence</b></span></div>
        </div>
      </section>
      <section className="landing-stats" id="impact"><div><strong>1,248</strong><span>Active volunteers</span></div><i /><div><strong>94</strong><span>Programs delivered</span></div><i /><div><strong>38K+</strong><span>Hours of service</span></div><i /><div><strong>18</strong><span>CMU units connected</span></div></section>
      <section className="mission-section" id="mission">
        <div className="section-heading"><span className="landing-eyebrow"><b>Why SBNu</b></span><h2>A stronger culture of<br/>service starts here.</h2><p>SBNu connects people, programs, and purpose—making it easier for every CMU student to contribute meaningfully.</p></div>
        <div className="mission-grid">
          <article><span>01</span><Icon name="spark" /><h3>Discover your purpose</h3><p>Find service opportunities aligned with your skills, interests, and community priorities.</p></article>
          <article><span>02</span><Icon name="people" /><h3>Serve together</h3><p>Collaborate across colleges and units through organized, high-impact volunteer programs.</p></article>
          <article><span>03</span><Icon name="trend" /><h3>See your impact</h3><p>Track attendance, service hours, milestones, and the difference your contribution creates.</p></article>
        </div>
      </section>
      <section className="programs-section" id="programs">
        <div className="programs-title"><span className="landing-eyebrow"><b>Programs</b></span><h2>There is a place for<br/>every kind of service.</h2><button onClick={() => onAuth("signup")}>View all opportunities <Icon name="arrow" /></button></div>
        <div className="program-stack">
          <article className="program-card program-green"><span>Environment</span><Icon name="heart" /><div><small>12 active programs</small><h3>Restore what sustains us.</h3><p>Watershed, campus greening, and community clean-up initiatives.</p></div></article>
          <article className="program-card program-blue"><span>Safety</span><Icon name="shield" /><div><small>8 active programs</small><h3>Build a culture of readiness.</h3><p>Training, preparedness drills, and resilient community support.</p></div></article>
          <article className="program-card program-gold"><span>Community</span><Icon name="people" /><div><small>17 active programs</small><h3>Extend care beyond campus.</h3><p>Education, outreach, relief, and civic engagement programs.</p></div></article>
        </div>
      </section>
      <section className="safety-feature" id="safety">
        <div className="safety-logo"><img src="/brand/odrrm.svg" alt="ODRRM logo" /></div>
        <div><span className="landing-eyebrow"><b>Powered by ODRRM readiness</b></span><h2>Service, with safety<br/>at the center.</h2><p>Access verified emergency contacts, submit safety reports, receive campus advisories, and connect with designated responders.</p><button onClick={() => onAuth("signin")}>Access the safety center <Icon name="arrow" /></button></div>
        <div className="safety-rings"><i /><i /><i /><Icon name="shield" /></div>
      </section>
      <section className="landing-cta"><img src="/brand/sbnu.svg" alt="" /><span className="landing-eyebrow"><b>Start serving today</b></span><h2>Your time can change<br/>someone’s tomorrow.</h2><p>Join the CMU SBNu volunteer network and turn your willingness to help into measurable impact.</p><button onClick={() => onAuth("signup")}>Create your volunteer account <Icon name="arrow" /></button></section>
    </main>
    <footer className="public-footer"><div className="public-brand"><img src="/brand/sbnu.svg" alt="SBNu logo" /><span><strong>SBNu</strong><small>CMU Volunteer Corps</small></span></div><p>Service • Bayanihan • Nationalism • Unity</p><div><img src="/brand/cmu.svg" alt="CMU" /><img src="/brand/odrrm.svg" alt="ODRRM" /></div></footer>
  </div>;
}
