export default function VolunteerActionGraphic({ compact = false }: { compact?: boolean }) {
  return <svg className={`action-graphic ${compact ? "compact" : ""}`} viewBox="0 0 620 620" role="img" aria-label="Isometric CMU volunteer community in action">
    <defs>
      <linearGradient id="ag-ground" x1="0" x2="1" y1="0" y2="1"><stop stopColor="#225f43"/><stop offset="1" stopColor="#0b3022"/></linearGradient>
      <linearGradient id="ag-gold" x1="0" x2="1" y1="0" y2="1"><stop stopColor="#f1cf75"/><stop offset="1" stopColor="#a87516"/></linearGradient>
      <linearGradient id="ag-stone" x1="0" x2="1" y1="0" y2="1"><stop stopColor="#f4f0e4"/><stop offset="1" stopColor="#bebaa9"/></linearGradient>
      <linearGradient id="ag-blue" x1="0" x2="1" y1="0" y2="1"><stop stopColor="#77a7b4"/><stop offset="1" stopColor="#315d69"/></linearGradient>
      <filter id="ag-shadow" x="-30%" y="-30%" width="160%" height="180%"><feDropShadow dx="0" dy="22" stdDeviation="18" floodColor="#00160e" floodOpacity=".34"/></filter>
      <filter id="ag-soft" x="-50%" y="-50%" width="200%" height="200%"><feGaussianBlur stdDeviation="18"/></filter>
      <clipPath id="ag-logo"><rect x="248" y="164" width="124" height="135" rx="12"/></clipPath>
    </defs>
    <ellipse cx="315" cy="512" rx="225" ry="48" fill="#061c14" opacity=".32" filter="url(#ag-soft)"/>
    <g filter="url(#ag-shadow)">
      <path d="m310 72 246 142-246 142L64 214Z" fill="url(#ag-ground)"/>
      <path d="m64 214 246 142v56L64 270Z" fill="#071f16"/>
      <path d="m556 214-246 142v56l246-142Z" fill="#0b2a1d"/>
      <path d="m310 103 190 110-190 110L120 213Z" fill="none" stroke="#d8b34e" strokeOpacity=".22" strokeWidth="2"/>
      <path d="M150 216 310 124l160 92-160 92Z" fill="#123f2c"/>
      <path d="m310 143 128 74-128 74-128-74Z" fill="#e7e1d2" fillOpacity=".08"/>
    </g>
    <g filter="url(#ag-shadow)">
      <path d="m310 118 76 44-76 44-76-44Z" fill="url(#ag-stone)"/>
      <path d="m234 162 76 44v116l-76-44Z" fill="#bcb8a8"/>
      <path d="m386 162-76 44v116l76-44Z" fill="#ded9ca"/>
      <path d="m252 160 58-34 58 34-58 34Z" fill="url(#ag-gold)"/>
      <image href="/brand/sbnu.svg" x="260" y="172" width="100" height="109" clipPath="url(#ag-logo)" preserveAspectRatio="xMidYMid meet"/>
    </g>
    <g filter="url(#ag-shadow)">
      <path d="m116 314 54-31 54 31-54 31Z" fill="#d5a83c"/><path d="m116 314 54 31v52l-54-31Z" fill="#9a7017"/><path d="m224 314-54 31v52l54-31Z" fill="#bb8c20"/>
      <path d="m396 335 45-26 45 26-45 26Z" fill="url(#ag-blue)"/><path d="m396 335 45 26v43l-45-26Z" fill="#2b535f"/><path d="m486 335-45 26v43l45-26Z" fill="#426f7a"/>
      <path d="M419 338h44M441 317v43" stroke="#f7f2e7" strokeWidth="7" strokeLinecap="round"/>
    </g>
    <g>
      <path d="M476 241v79" stroke="#7f5b18" strokeWidth="13" strokeLinecap="round"/>
      <path d="M476 274c-37-4-55-25-49-55 28 1 48 18 49 55Z" fill="#4f8b5f"/>
      <path d="M477 253c31-3 47-21 42-46-24 1-41 15-42 46Z" fill="#79a86e"/>
      <path d="M476 230c-21-8-28-23-18-42 18 7 25 21 18 42Z" fill="#b4bd6b"/>
    </g>
    <g filter="url(#ag-shadow)">
      <g transform="translate(104 214)"><ellipse cx="29" cy="95" rx="34" ry="10" fill="#03180f" opacity=".24"/><circle cx="29" cy="19" r="17" fill="#d7a579"/><path d="M10 39c12-9 26-9 38 0l7 39H4Z" fill="#e6bb4e"/><path d="m13 74-5 49M46 74l8 49" stroke="#183e2c" strokeWidth="10" strokeLinecap="round"/><path d="m10 44-23 34M49 44l22 26" stroke="#d7a579" strokeWidth="9" strokeLinecap="round"/></g>
      <g transform="translate(432 290)"><ellipse cx="29" cy="95" rx="34" ry="10" fill="#03180f" opacity=".24"/><circle cx="29" cy="19" r="17" fill="#a86f4d"/><path d="M10 39c12-9 26-9 38 0l7 39H4Z" fill="#f0eee4"/><path d="m13 74-5 49M46 74l8 49" stroke="#244f5a" strokeWidth="10" strokeLinecap="round"/><path d="m10 44-20 30M49 44l24 17" stroke="#a86f4d" strokeWidth="9" strokeLinecap="round"/></g>
      <g transform="translate(240 350)"><ellipse cx="29" cy="95" rx="34" ry="10" fill="#03180f" opacity=".24"/><circle cx="29" cy="19" r="17" fill="#cc9265"/><path d="M10 39c12-9 26-9 38 0l7 39H4Z" fill="#4a7d62"/><path d="m13 74-5 49M46 74l8 49" stroke="#d9d3c4" strokeWidth="10" strokeLinecap="round"/><path d="m10 44-24 22M49 44l24 22" stroke="#cc9265" strokeWidth="9" strokeLinecap="round"/></g>
    </g>
    <g fill="none" stroke="#e8c760" strokeLinecap="round"><path d="M84 145c48-70 113-105 195-113" opacity=".34"/><path d="M507 117c27 22 48 50 62 84" opacity=".34"/><path d="M166 475c52 35 109 51 171 48" opacity=".2"/></g>
  </svg>;
}
