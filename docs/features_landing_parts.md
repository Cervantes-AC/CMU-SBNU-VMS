# Comprehensive Documentation for `parts`

**Path:** `lib/features/landing/parts/`

## Files

### 📄 `feature_card_widget.dart`
**Defined Types & Details:**

#### `_FeatureCardWidget` extends StatefulWidget
- **Fields / Properties:**
  - `icon`
  - `color`
  - `title`
  - `desc`
- **Methods:**
  - `createState()`

#### `_FeatureCardWidgetState` extends State<_FeatureCardWidget>
- **Fields / Properties:**
  - `_hovered`
  - `c`
  - `s`
- **Methods:**
  - `build()`

---

### 📄 `landing_about.dart`
**Defined Types & Details:**

#### `_LandingAboutSection` on _LandingPageState
- **Fields / Properties:**
  - `s`
  - `compact`
  - `isMobile`
- **Methods:**
  - `_buildStatsBar()`
  - `_buildAbout()`
  - `_missionBrief()`
  - `_valuesTimeline()`

#### `_SignalTag` extends StatelessWidget
- **Fields / Properties:**
  - `label`
  - `color`
  - `scale`
- **Methods:**
  - `_SignalTag()`
  - `build()`

---

### 📄 `landing_app_bar.dart`
**Defined Types & Details:**

#### `_LandingAppBarSection` on _LandingPageState
- **Fields / Properties:**
  - `s`
- **Methods:**
  - `_buildAppBar()`
  - `_navBtn()`
  - `_setLandingState()`

---

### 📄 `landing_contact_footer.dart`
**Defined Types & Details:**

#### `_ContactRateLimiter` 
- **Fields / Properties:**
  - `last`
  - `true`
- **Methods:**
  - `allow()`
  - `reset()`

#### `_LandingContactFooterSection` on _LandingPageState
- **Fields / Properties:**
  - `s`
  - `compact`
- **Methods:**
  - `_buildContact()`
  - `_contactPanel()`
  - `_requestPanel()`
  - `_setLandingState()`
  - `_darkDivider()`
  - `_buildFooter()`
  - `_footerBrand()`
  - `_footerLink()`
  - `_footerCol()`

---

### 📄 `landing_hero.dart`
**Defined Types & Details:**

#### `_LandingHeroSection` on _LandingPageState
- **Fields / Properties:**
  - `s`
  - `compact`
  - `isMobile`
- **Methods:**
  - `_buildHero()`

#### `_AnimatedGradientBg` extends StatefulWidget
- **Fields / Properties:**
  - `controller`
- **Methods:**
  - `_AnimatedGradientBg()`
  - `createState()`

#### `_AnimatedGradientBgState` extends State<_AnimatedGradientBg>
- **Fields / Properties:**
  - `t`
- **Methods:**
  - `initState()`
  - `dispose()`
  - `build()`

#### `_PulseChip` extends StatefulWidget
- **Fields / Properties:**
  - `label`
  - `scale`
- **Methods:**
  - `_PulseChip()`
  - `createState()`

#### `_PulseChipState` extends State<_PulseChip>
- **Methods:**
  - `initState()`
  - `dispose()`
  - `build()`

#### `_GlassButton` extends StatelessWidget
- **Fields / Properties:**
  - `label`
  - `icon`
  - `isPrimary`
  - `onTap`
  - `scale`
- **Methods:**
  - `build()`

#### `_HeroMetricGlass` extends StatelessWidget
- **Fields / Properties:**
  - `value`
  - `label`
  - `s`
- **Methods:**
  - `_HeroMetricGlass()`
  - `build()`

#### `_HeroBgPainter` extends CustomPainter
- **Fields / Properties:**
  - `t`
  - `hue`
  - `phase`
- **Methods:**
  - `_HeroBgPainter()`
  - `paint()`
  - `shouldRepaint()`

---

### 📄 `landing_modals.dart`
**Defined Types & Details:**

#### `_LandingModalsSection` on _LandingPageState
- **Fields / Properties:**
  - `i`
  - `p`
  - `s`
- **Methods:**
  - `_buildProgramModal()`
  - `_setLandingState()`
  - `_capabilityChip()`
  - `_impactStat()`
  - `_buildPrivacyModal()`
  - `_privacyCard()`

---

### 📄 `landing_programs.dart`
**Defined Types & Details:**

#### `_LandingProgramsSection` on _LandingPageState
- **Fields / Properties:**
  - `s`
  - `compact`
  - `p`
- **Methods:**
  - `_buildPrograms()`
  - `_programCard()`

#### `_ProgramMissionCard` extends StatefulWidget
- **Fields / Properties:**
  - `color`
  - `icon`
  - `title`
  - `description`
  - `volunteers`
  - `hours`
  - `events`
  - `index`
  - `onTap`
- **Methods:**
  - `createState()`

#### `_ProgramMissionCardState` extends State<_ProgramMissionCard>
- **Fields / Properties:**
  - `_hovered`
  - `s`
- **Methods:**
  - `build()`

---

### 📄 `landing_shared_widgets.dart`
**Defined Types & Details:**

#### `_LandingSharedWidgets` on _LandingPageState
- **Methods:**
  - `_sectionLabel()`
  - `_primaryBtn()`
  - `_successBanner()`
  - `_logo()`

#### `_HeroContent` on _LandingPageState
- **Fields / Properties:**
  - `s`

---

