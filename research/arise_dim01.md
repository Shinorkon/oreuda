# Dimension 01: Solo Leveling Visual Design System

## Research Summary

This document translates Solo Leveling's iconic visual language into concrete UI design system specifications for the ARISE app. Research draws from the anime's System interface, manhwa art, game UI (Solo Leveling: ARISE), cyberpunk/holographic UI design patterns, Material Design 3 constraints, and accessibility standards. **Total searches conducted: 19.**

---

## Color Palette Specification

### Core Background Colors

| Color Name | Hex Code | Usage | Source Reference |
|---|---|---|---|
| `System Black` | `#000000` | Deepest background, void space behind System panels | Anime System backdrop [^1^][^6^] |
| `Void Navy` | `#030712` | Primary app background, Penalty Zone sky reference | Penalty Zone described as "sky like black ink" [^103^] |
| `Deep Abyss` | `#0B1426` | Secondary background, card surfaces, System panel base | Manhwa System UI dark panels [^287^] |
| `Slate Surface` | `#111827` | Elevated surfaces, modals, inventory grid cells | Material 3 surface adaptation [^337^] |
| `Panel Fill` | `#162032` | Active states, selected items, hover backgrounds | Anime status window interior [^4^] |

### Holographic Blue/Cyan Spectrum

| Color Name | Hex Code | Usage | Source Reference |
|---|---|---|---|
| `Holographic Cyan` | `#00E5FF` | Primary accent, neon borders, active buttons, scan lines | Anime System glowing borders [^1^][^6^] |
| `System Blue` | `#2196F3` | Secondary accent, links, interactive elements | Manhwa blue status panels [^274^] |
| `Deep Cyan` | `#0097A7` | Tertiary accent, dividers, subtle highlights | Gate portal energy blue [^2^] |
| `Aether Blue` | `#4FC3F7` | Glow effects, particle accents, soft highlights | Inventory screen item glow [^5^] |
| `Frost Edge` | `#80DEEA` | Border highlights, hover glows, edge illumination | Anime notification panel rim [^6^] |

### Status & Accent Colors

| Color Name | Hex Code | Usage | Source Reference |
|---|---|---|---|
| `Arise Gold` | `#FFD700` | Premium elements, S-Rank badges, legendary items, level-ups | Manhwa gold/black UI theme [^287^] |
| `Shadow Gold` | `#FFB300` | Secondary gold, progress bars, achievements | Black-gold UI variant [^287^] |
| `HP Crimson` | `#FF1744` | Health bars, danger warnings, penalty alerts, Red Gates | HP bar in status screen [^4^] |
| `Alert Red` | `#FF3D00` | Critical notifications, failure states, emergency takeover | Red Gate warning color [^399^] |
| `Success Green` | `#00E676` | Quest completion, stat increases, positive feedback | Job change positive notifications [^406^] |
| `MP Azure` | `#2979FF` | Mana/energy bars, magic-related UI elements | MP bar in status screen [^4^] |

### Gate Color System

| Color Name | Hex Code | Usage | Source Reference |
|---|---|---|---|
| `Gate Blue` | `#00B0FF` | Normal gates, standard dungeon portals, B-C rank content | Normal gate portals [^2^][^3^] |
| `Gate Red` | `#FF1744` | Red Gates, danger warnings, trapped-state alerts | Red Gate anime appearance [^399^][^8^] |
| `Gate Purple` | `#E040FB` | S-Rank gates, endgame content, Monarch-related events | S-Rank dungeon visual aura |
| `Gate Amber` | `#FFC400` | A-Rank gates, high-tier warnings | A-Rank gate classification |

### Text Colors

| Color Name | Hex Code | Usage | Source Reference |
|---|---|---|---|
| `Pure White` | `#FFFFFF` | Primary headings, critical data, HP/MP values | Anime status text [^4^] |
| `System Silver` | `#B0BEC5` | Secondary text, descriptions, stat labels | Manhwa panel text [^274^] |
| `Muted Ash` | `#78909C` | Tertiary text, timestamps, disabled states | System muted descriptions |
| `Bracket Cyan` | `#00E5FF` | `[Notification]` brackets, system command text, labels | Notification brackets in anime [^6^] |

### Usage Rules
- Background layers should use `Void Navy` → `Deep Abyss` → `Slate Surface` with increasing elevation [^337^]
- All holographic blue accents should be paired with subtle glow effects (box-shadow: 0 0 20px rgba(0,229,255,0.3)) [^378^]
- `Arise Gold` must be reserved for truly significant moments (level-ups, rare items, S-Rank achievements) to maintain its emotional weight [^287^]
- `Alert Red` should only appear with animation — never static on dark backgrounds to avoid visual fatigue [^340^]

---

## Typography System

### Primary Typefaces

| Font Family | Usage | Fallback Stack | Weight | Source Reference |
|---|---|---|---|---|
| `JetBrains Mono` | Stat values, HP/MP numbers, countdown timers, data displays | `'JetBrains Mono', 'Fira Code', 'Courier New', monospace` | 400, 700 | Terminal/cyberpunk UI research [^372^][^376^] |
| `Share Tech Mono` | System notifications, bracketed text `[Notification]`, command prompts | `'Share Tech Mono', 'IBM Plex Mono', monospace` | 400 | Cyberpunk terminal style recommendation [^372^] |
| `Inter` | Body text, descriptions, quest details, readable content | `'Inter', 'Roboto', 'SF Pro Display', sans-serif` | 400, 500, 600 | Material Design 3 sans-serif pairing [^339^] |
| `Orbitron` | Section headers, rank displays, dramatic titles (sparingly) | `'Orbitron', 'Rajdhani', 'Arial', sans-serif` | 500, 700, 900 | Futuristic gaming UI aesthetic [^379^] |

### Type Scale

| Token | Size | Weight | Font | Usage |
|---|---|---|---|---|
| `Display` | 36-48sp | 700/900 | Orbitron | Level-up announcements, rank titles, "ARISE" command |
| `Header` | 24-28sp | 600 | Inter | Screen titles, quest names, section headers |
| `Subheader` | 18-20sp | 500 | Inter | Panel titles, category labels |
| `Body` | 16sp | 400 | Inter | Descriptions, quest text, general content |
| `Data` | 16-20sp | 700 | JetBrains Mono | Stat values (STR: 97), HP/MP numbers, timers |
| `Caption` | 12-14sp | 400 | JetBrains Mono | Labels, timestamps, small data |
| `System` | 14sp | 400 | Share Tech Mono | `[Notification]` brackets, system messages |
| `Button` | 14-16sp | 600 | Inter | CTA text, action buttons |

### Typography Rules
- Monospace fonts (JetBrains Mono, Share Tech Mono) must be used for ALL numerical data to maintain System-like data presentation [^302^]
- Bracketed notifications `[Notification]` must use Share Tech Mono to evoke the clinical System voice [^23^]
- Orbitron should be used sparingly — only for moments of maximum drama (level up, rank up, "Arise" activation) [^379^]
- Minimum contrast ratio: 4.5:1 for body text, 7:1 for high-contrast mode following WCAG AAA [^343^][^346^]

---

## Animation Specifications

### Core System Animations

| Animation Name | CSS/Flutter Properties | Duration | Easing | Source Reference |
|---|---|---|---|---|
| `GlitchAppear` | clip-path steps + translateX flicker + opacity 0→1 | 300-400ms | steps(5) | Glitch text effect research [^378^][^385^] |
| `HologramFlicker` | opacity 0.85→1.0→0.9 + subtle brightness filter oscillation | 2-3s loop | ease-in-out infinite | Holographic CSS effects [^382^] |
| `ScanLineReveal` | translateY 100%→0% + opacity with scanline overlay pattern | 400-600ms | cubic-bezier(0.4, 0, 0.2, 1) | CRT scanline research [^378^] |
| `DataStream` | background-position shift on oversized gradient layer | 6-8s loop | ease-in-out infinite | Datastream animation [^378^] |
| `TypewriterText` | width 0→100% with overflow hidden + border-right blink | 30ms/character | linear | Terminal typewriter effect |
| `PanelMaterialize` | scale 0.95→1.0 + opacity 0→1 + border-glow intensity increase | 250ms | cubic-bezier(0.4, 0, 0.2, 1) | Anime panel appearance |
| `StatIncrement` | translateY bounce + color flash (white→gold→white) | 200ms | ease-out | RPG stat increase pattern |
| `QuestPopup` | slideIn from top + opacity + border-glow pulse once | 350ms | spring(damping: 15) | Quest notification in anime [^6^] |
| `WarningPulse` | scale 1.0→1.02→1.0 + red glow intensity oscillation | 1.5s loop | ease-in-out infinite | Penalty quest warning [^102^] |
| `ShadowExtract` | opacity 0→1 + translateY(20px→0) + particle burst | 500-800ms | ease-out | "Arise" shadow extraction moment [^101^][^106^] |

### Animation Principles
- All animations must respect `prefers-reduced-motion` — provide instant state changes as fallback [^378^][^382^]
- The System appears with a brief glitch flicker (50-100ms) before stabilizing — this communicates the digital/holographic nature of the interface [^378^]
- Scanlines should be subtle (opacity 0.05-0.1) — present as atmospheric texture, not dominant visual [^378^]
- Particle effects should use cyan/blue (#00E5FF) with varying opacity and size for depth [^382^]

---

## Layout Grid System

### Screen Types

| Screen Type | Layout Description | Key Elements |
|---|---|---|
| `Status Window` | Centered modal, ~85% width, rounded corners with holographic border, dark translucent background | HP/MP bars, stat grid (STR/AGI/VIT/INT/SEN/STA), level display, rank badge, remaining points [^4^] |
| `Notification Popup` | Centered dialog, ~75% width, bracketed header `[Notification]`, Yes/No action buttons | Warning icon, clinical message text, countdown timer (if time-limited), accept/decline actions [^6^] |
| `Quest Panel` | Slide-in from top, full-width header with `[Quest]` label, expandable details | Quest title, goal checklist (0/100), reward preview, warning footer about penalties [^7^] |
| `Inventory Grid` | Scrollable grid, 3-4 columns on mobile, item slots with cyan borders, category tabs | Equipment/Consumables/Materials tabs, item cards with icons + names + quantities, gold display [^5^] |
| `Shop Interface` | Split layout: buy/sell toggle, item list with prices, player gold display at bottom | Category filters, item rows with icon/name/price, purchase quantity selector [^8^] |
| `Daily Quest` | Full-screen takeover, checklist format with checkboxes, warning banner at bottom | Exercise goals (push-ups/sit-ups/squats/running), progress counters, penalty warning [^7^] |
| `Rank Badge` | Floating chip element, hexagonal or shield shape, letter grade centered | E/D/C/B/A/S letter, color-coded border, subtle glow matching rank tier [^24^] |

### Layout Rules
- System windows float above all content with `z-index: 100` and backdrop blur (4-8px) on the underlying screen [^379^]
- All System panels have holographic cyan borders (1-2px solid with outer glow) [^1^][^6^]
- Padding inside panels: 16dp (mobile), 24dp (tablet) [^339^]
- Border radius: 8-12dp for panels, 4dp for buttons, 50% for circular elements [^337^]
- Spacing between stat rows: 12dp; between sections: 24dp

---

## Iconography Standards

### Icon Categories

| Icon Category | Style Description | Size | Color Treatment |
|---|---|---|---|
| `Rank Badges` | Hexagonal shield shape with letter (E-S) centered, geometric angular edges | 32-48dp | E: #78909C gray, D: #4CAF50 green, C: #2196F3 blue, B: #9C27B0 purple, A: #FF9800 amber, S: #FFD700 gold with glow [^24^] |
| `Gate/Dungeon` | Circular swirling portal with energy tendrils, concentric rings | 48-64dp | Normal: `Gate Blue` gradient, Red Gate: `Gate Red` with crack overlay, S-Rank: `Gate Purple` with particle effects [^2^][^399^] |
| `Stats` | Minimal line icons — dumbbell (STR), wing (AGI), heart (VIT), brain (INT), eye (SEN), shield (STA) | 20-24dp | `Holographic Cyan` with `System Silver` inactive state [^4^] |
| `Items` | Flat + subtle glow style, silhouette-based with cyan accent for magical items | 40-48dp | Grayscale base + `Aether Blue` glow for magical, `Arise Gold` for legendary |
| `Status Effects` | Small circular badges with symbolic icons (poison, buff, debuff) | 16-20dp | Red for negative, green for positive, gold for special |
| `System` | Bracket-style `[ ]` icons for notification types, gear for settings, bag for inventory | 24dp | `Bracket Cyan` |
| `Navigation` | Minimal outline style with cyan active state, muted ash inactive | 24dp | Active: `Holographic Cyan`, Inactive: `Muted Ash` |

### Icon Rules
- All icons follow a consistent 2px stroke width for outline style [^339^]
- Active/selected states include a subtle cyan glow (box-shadow: 0 0 8px rgba(0,229,255,0.4)) [^378^]
- S-Rank and legendary items use a pulsing gold glow animation to signal rarity [^287^]
- Icons must have 48dp minimum touch targets for accessibility [^46^]

---

## Screen Transition Patterns

| Transition Name | Description | Implementation |
|---|---|---|
| `SystemActivate` | Dark overlay fades in → glitch flicker at center → System panel materializes with border glow pulse | opacity 0→1 (150ms) + glitch clip (100ms) + scale 0.95→1 + glow (250ms) [^378^] |
| `SystemDismiss` | Border glow fades → panel shrinks 0.98 with opacity fade → glitch flicker → gone | glow fade (100ms) + scale + opacity (200ms) + glitch (50ms) |
| `QuestArrive` | Panel slides from top edge with scanline wipe, settling with subtle bounce | translateY(-100%→0) + scanline overlay + spring settle (350ms) [^6^] |
| `LevelUp` | Gold flash fills screen → "LEVEL UP" text scales in with Orbitron → stat window materializes | gold overlay flash (200ms) + text scale (400ms) + panel appear (300ms) |
| `PenaltyWarning` | Red border pulse intensifies → screen shake 2px → warning text types in | border pulse + translateX shake (2px, 3 cycles) + typewriter |
| `GateOpen` | Circular portal expands from center point, swirling energy animation, screen dims around edges | scale 0→1 portal + rotate infinite swirl + vignette darken |
| `ShadowExtract` | Dark particles converge on target point → silhouette forms → "ARISE" text flashes → extraction complete | particle convergence (600ms) + silhouette fade + text flash (200ms) [^101^] |
| `NotificationUrgent` | Full-screen takeover: system notification expands to fill entire viewport, background completely obscured | scale expansion (300ms) + backdrop blur max |

---

## Full-Screen Takeover Design

### Elements

| Element | Specification | Source Reference |
|---|---|---|
| `Background` | Pure black `#000000` with subtle animated particle field (cyan dots, opacity 0.1-0.3) | Penalty Zone "sky like black ink" [^103^] |
| `Container` | 90% width, centered, holographic cyan border with outer glow, dark translucent fill | Anime notification panels [^6^] |
| `Header` | `[NOTIFICATION]` or `[WARNING]` in bracketed cyan text, Share Tech Mono font | System notification style [^6^] |
| `Message` | Centered, large text (20-24sp), clinical authoritative tone, white on dark | System voice: "Your heart will stop in 3.02 seconds" [^6^] |
| `Countdown` | Prominent timer (JetBrains Mono, 48sp+) for time-limited decisions, pulsing red under 10s | Time-limited quest accept screen |
| `Actions` | Binary choices when applicable: "Yes" / "No" — minimal buttons with cyan border glow | Notification dialog buttons [^6^] |
| `Vibration` | Haptic feedback on appearance, escalating pattern for warnings | Android haptic API |
| `Audio` | Subtle system chime on appearance — clinical, not musical | System notification sound design |

### Full-Screen Rules
- Full-screen takeovers must bypass do-not-disturb for critical daily quest deadlines [^46^]
- Require explicit user action to dismiss — no tap-outside-to-close for penalty warnings [^46^]
- On Android 14+, use Full-Screen Intent notifications with proper alarm category declaration [^46^]
- Display over lock screen with `FLAG_SHOW_WHEN_LOCKED` and `FLAG_KEEP_SCREEN_ON` [^11^]
- Maximum urgency: screen wakes, alarm sound plays, haptic activates simultaneously

---

## Key Design Principles

| Principle | Rationale |
|---|---|
| **Severity with Beauty** | The System is clinical and authoritative but visually stunning. Use dark backgrounds as canvas for luminous cyan accents. The beauty of the interface offsets the harshness of its messages, creating an addictive visual tension. [^340^][^383^] |
| **The System Doesn't Ask — It Informs** | All System text uses declarative statements, not questions. "The daily quest has arrived." Not "Would you like to complete a quest?" This clinical authority is core to the aesthetic. [^23^] |
| **Every Pixel Earns Its Place** | Dark UI must avoid clutter. Generous whitespace between elements. Each glow, each particle, each animation must serve a purpose. Breathing room is as important as content. [^383^] |
| **Cyan is the Signature** | The holographic cyan (#00E5FF) is the most recognizable visual element of the System. It must appear in every screen — as a border, a glow, or an accent. Without it, the interface is just another dark theme. [^1^][^6^] |
| **Gold is Sacred** | Reserve `Arise Gold` for genuinely significant moments. Overuse dilutes its emotional impact. A level-up should feel golden; a settings menu should not. [^287^] |
| **Data is Alive** | Numbers should animate on change (StatIncrement). HP bars should deplete with urgency. Progress should fill with visible momentum. Static data feels dead; the System feels alive. [^23^] |
| **Darkness Enables Focus** | The dark background isn't depressing — it's a focusing tool. Like a cinema, darkness directs attention precisely where light exists. Use darkness to create visual hierarchy through illumination, not color volume. [^344^] |
| **Accessibility is Non-Negotiable** | All text meets WCAG AA (4.5:1) minimum, AAA (7:1) preferred. High-contrast mode must be available. Animations respect reduced-motion preferences. The System is for everyone. [^343^][^346^] |
| **Full-Screen = Full Presence** | When the System demands attention, it dominates the entire viewport — just as it dominates Jin-woo's vision. No background peeking through, no status bar distraction. Total immersion. [^46^] |
| **Holographic Depth** | Layers of translucent panels with varying blur and glow create depth. The System doesn't feel flat — it feels projected into space. Use elevation overlays and backdrop blur to achieve this. [^379^][^382^] |
| **Respect the Source** | The manhwa's black-gold UI and the anime's blue holographic UI are both valid interpretations. The app should default to anime cyan (wider recognition) with a "Manhwa Mode" option for gold accents. [^287^] |

---

## Material Design 3 Integration Notes

### Dynamic Color Adaptation
- Primary color: Override with `Holographic Cyan` (#00E5FF) instead of wallpaper-derived color [^337^][^339^]
- On Android 12+, suppress dynamic color to maintain the System's signature cyan identity [^338^]
- Dark theme is the only theme — no light mode option (it would break the immersion) [^344^]
- Surface colors: Use `Deep Abyss` (#0B1426) as surface, `Slate Surface` (#111827) as surfaceContainer [^337^]

### Component Overrides
- Buttons: Outlined style with cyan border, filled style with cyan background on dark [^339^]
- Cards: Dark translucent with subtle border, no elevation shadow (use glow instead) [^382^]
- Progress indicators: Cyan track, dark inactive track, HP/MP variants use their respective colors [^342^]
- Switches: Cyan thumb, dark track — no Material purple [^339^]
- Navigation: Bottom nav with cyan active indicator, no labels to maintain clean aesthetic [^339^]

### Accessibility Compliance
- Minimum touch target: 48dp × 48dp for all interactive elements [^46^]
- Contrast ratios: 4.5:1 minimum for body text, 3:1 for large text, 7:1 for AAA mode [^343^][^346^]
- High-contrast mode option: Pure black background + pure white text + neon yellow accents [^344^]
- Screen reader support: All bracketed notifications read aloud, haptic feedback for critical alerts [^340^]

---

## Implementation References

### Color Extraction from Sources
- Anime System border: Extracted cyan glow from notification panels [^1^][^6^]
- Manhwa gold accent: Community preference for black-gold UI variant [^287^]
- Gate energy: Blue portal swirl from anime and manhwa [^2^][^3^]
- Red Gate warning: Crimson/red-purple energy from danger gates [^399^][^8^]
- Penalty Zone: Absolute black void reference [^103^]

### Typography Sources
- JetBrains Mono: Recommended for terminal/game UI [^372^][^376^]
- Share Tech Mono: Recommended for cyberpunk terminal aesthetic [^372^]
- Orbitron: Futuristic header font for gaming interfaces [^379^]
- Inter: Material 3-compatible sans-serif [^339^]

### Animation Sources
- Cybercore CSS: Glitch text, neon borders, scanlines, datastream [^378^]
- Holographic CSS: Layered gradients, blend modes, OKLCH color space [^382^]
- CSS button animations: Glitch effect, hologram button, scan line [^385^]

### Android Implementation
- Full-screen intents: Alarm/notification takeover pattern [^46^][^11^]
- Material 3 dynamic colors: Override for brand consistency [^337^][^338^][^339^]
- Dark mode accessibility: WCAG compliance guidelines [^340^][^343^][^346^]

---

## Citations

[^1^]: Solo Leveling UI by azmangg on DeviantArt — Status window with HP/MP bars, STR/VIT/INT/AGI/PER stats, cyan border design: https://www.deviantart.com/azmangg/art/Solo-Leveling-UI-1197944350

[^2^]: Solo Leveling Wiki — Gates, blue energy portal with lightning effects: https://solo-leveling.fandom.com/wiki/Gates

[^3^]: CBR — Gates in Solo Leveling Explained, swirling blue portal anime screenshot: https://www.cbr.com/solo-leveling-gates-explained/

[^4^]: Roblox DevForum — UI designs based on Solo Leveling manhwa reference, STATUS screen with HP/MP bars and stat layout: https://devforum.roblox.com/t/some-ui-designs-i-made-off-a-manhwa-reference-solo-leveling/941145

[^5^]: CBR — Solo Leveling OP Inventory, healing potion shop screen with glowing item icons: https://www.cbr.com/solo-leveling-anime-manhwa-sung-jinwoo-major-abilities-skills-explained/

[^6^]: Heroism Wiki — System Solo Leveling anime notification screen: https://heroism.fandom.com/wiki/System_(Solo_Leveling)

[^7^]: GameRant — Every Quest Sung Jin-Woo Completed, daily quest goal checklist screenshot: https://gamerant.com/solo-leveling-every-quest-sung-jin-woo-completed-anime/

[^8^]: GameRant — Solo Leveling: Jinwoo Is Underutilizing the Shop System, SHOP UI with buy/sell tabs and weapon list: https://gamerant.com/solo-leveling-jinwoo-underutilizing-shop-system/

[^11^]: Medium — Creating an alarm using AlarmManager in Android, wake-up patterns: https://mubaraknative.medium.com/creating-a-alarm-using-alarmmanager-in-android-e27a4283d39f

[^23^]: Solo Leveling Wiki — System, stat descriptions (STR/AGI/STA/INT/SEN), video-game interface design: https://solo-leveling.fandom.com/wiki/System

[^24^]: Solo Leveling Wiki — Class Ranks, E-S ranking system with power differences: https://solo-leveling.fandom.com/wiki/Class_Ranks

[^26^]: Solo Leveling Wiki reference — Time pauses when Jin-woo opens the System

[^46^]: ProAndroidDev — Full-Screen Intent Notifications in Android 14 & 15: https://proandroiddev.com/full-screen-intent-fsi-notifications-in-android-14-15-what-changed-why-its-breaking-and-e5e862a75936

[^64^]: Solo Leveling Wiki reference — Demon Castle, burning replica of Seoul, 100 floors

[^101^]: Solo Leveling Wiki reference — Command word "Arise" for Shadow Extraction

[^102^]: Solo Leveling Wiki — Survival penalty quest for failing daily quest: https://solo-leveling.fandom.com/wiki/Survival

[^103^]: Solo Leveling Wiki — Penalty Zone, desert with no wind/sun/moon/stars: https://solo-leveling.fandom.com/wiki/Penalty_Zone

[^106^]: Solo Leveling Wiki reference — "Arise" activation phrase for Shadow Extraction

[^124^]: Solo Leveling Wiki reference — System uses blue holographic screen interface

[^128^]: Solo Leveling Wiki reference — System interface appears anywhere, anytime

[^274^]: CurseForge — Solo Leveling Anime UI Minecraft texture pack, purple/blue theme: https://www.curseforge.com/minecraft-bedrock/texture-packs/solo-levelling-anime-ui-sung-jin-woo-animated-ui

[^275^]: TikTok — Understanding S Rank vs E Rank in Solo Leveling: https://www.tiktok.com/@dreamerbubbles/video/7642893617262087437

[^277^]: Reddit — Solo Leveling Ranking System analysis: https://www.reddit.com/r/sololeveling/comments/p8nq71/solo_leveling_ranking_system/

[^278^]: YouTube — Solo Leveling: ARISE UI/UX explained: https://www.youtube.com/watch?v=0eQSyLpXlx8

[^279^]: Behance — Solo Leveling UI Projects: https://www.behance.net/search/projects/solo%20leveling%20ui

[^280^]: Behance — Solo Leveling Overlay Projects: https://www.behance.net/search/projects/solo%20leveling%20overlay

[^281^]: Reddit — UI Design Ideas for Solo Leveling: Arise Code: https://www.reddit.com/r/UI_Design/comments/1ptyudm/need_ui_design_ideas_for_my_solo_leveling_arise/

[^282^]: Dribbble — Solo Leveling UI Concept Figma Design: https://dribbble.com/shots/25916934-Solo-Leveling-UI-Concept-Figma-Design

[^283^]: YouTube — Solo Leveling Arise Tutorial: Learning the Basics UI: https://www.youtube.com/watch?v=UTvsK8Tl3_A

[^285^]: Lemon8 — Sung Jinwoo character deep dive, blue-purple energy description: https://www.lemon8-app.com/@chronictaku20/7462111829222015534

[^286^]: Roblox DevForum — Some UI designs made off Solo Leveling manhwa reference: https://devforum.roblox.com/t/some-ui-designs-i-made-off-a-manhwa-reference-solo-leveling/941145

[^287^]: Reddit — "Which System interface do you prefer? The black-gold UI goes really hard!": https://www.reddit.com/r/sololeveling/comments/1j3divf/which_system_interface_do_you_prefer_the/

[^288^]: Dribbble — Solo Leveling design inspiration: https://dribbble.com/search/sololeveling

[^289^]: Figma — Solo Leveling Game Interface community file: https://www.figma.com/community/file/1459229789167769742/solo-leveling

[^300^]: TV Tropes — Nightmare Fuel in Solo Leveling, System daily quest penalty: https://tvtropes.org/pmwiki/pmwiki.php/NightmareFuel/SoloLeveling

[^301^]: VS Code — Terminal Appearance documentation, monospace fonts: https://code.visualstudio.com/docs/terminal/appearance

[^302^]: CSS Author — 65+ Best Free Monospace Fonts for Coding & Design 2026: https://cssauthor.com/best-free-monospace-fonts-for-coding/

[^304^]: Reddit — "It's a shame the series doesn't show much of the system": https://www.reddit.com/r/sololeveling/comments/1j80l3x/its_a_shame_the_series_doesnt_show_much_of_the/

[^337^]: GitHub Gist — Material 3 Dynamic Colour Theming Android Setup: https://gist.github.com/SagarDevAchar/65ca639e8ce8e2877aa5adcdd2ad553a

[^338^]: Dev.to — Material3 Dynamic Colors: How AI Gets Android Theming Right: https://dev.to/myougatheaxo/material3-dynamic-colors-how-ai-gets-android-theming-right-and-you-can-too-31nm

[^339^]: Android Developer — Material Design 3 in Compose: https://developer.android.com/develop/ui/compose/designsystems/material3

[^340^]: WildnetEdge — Designing for Dark Mode: UI Tips and Tools: https://www.wildnetedge.com/blogs/dark-mode-ui-essential-tips-for-color-palettes-and-accessibility

[^341^]: Material3 Themes Manual — Introducing Material 3 Color System: https://material3-themes-manual.amoebelabs.com/basics/introducing-m3-color-system/

[^342^]: ProAndroidDev — Material3 Color System Basics for Android Developers: https://proandroiddev.com/material3-color-system-basics-for-android-developers-2b0c73a58b2d

[^343^]: Altitude Design — A Practical Guide to Color Contrast Accessibility Guidelines: https://altitudedesign.co.uk/blog/color-contrast-accessibility-guidelines

[^344^]: UX Design CC — High-contrast: when you think dark mode is enough: https://uxdesign.cc/high-contrast-when-you-think-the-dark-mode-is-enough-d190218d4bba

[^345^]: Medium — How to Design Accessible Dark Mode Interfaces: https://medium.com/@tundehercules/how-to-design-accessible-dark-mode-interfaces-17f38ecea2e9

[^346^]: MDN Web Docs — Color contrast accessibility: https://developer.mozilla.org/en-US/docs/Web/Accessibility/Guides/Understanding_WCAG/Perceivable/Color_contrast

[^372^]: GitHub — GusRPG/cyberpunk-starfinder-terminal-style (fonts): https://github.com/GusRPG/cyberpunk-starfinder-terminal-style

[^373^]: YouTube — Manhwa Vs Anime (Jeju Island Raid) comparison: https://www.youtube.com/watch?v=pmGeWX6w8PI

[^374^]: YouTube — Manhwa Vs Anime (Jinwoo Vs. Baran): https://www.youtube.com/watch?v=aWRvKcDFC6M

[^375^]: YouTube — Manhwa Vs Anime (Season 2 Finale) comparison: https://www.youtube.com/watch?v=exIFkFGS4hU

[^376^]: VS Code Marketplace — Neon Cyberpunk Theme (Fira Code, JetBrains Mono): https://marketplace.visualstudio.com/items?itemName=LittleWaterfall.neon-cyberpunk-theme

[^377^]: YouTube — Solo Leveling Season 2: Manhwa vs Anime Full Comparison: https://www.youtube.com/watch?v=bvE-g98svgM

[^378^]: CSS Script — Cybercore CSS Framework for Dark UI (glitch, neon, scanlines): https://www.cssscript.com/cyberpunk-css-framework-cybercore/

[^379^]: PureCode — Jarvis AI React Tailwind Component (holographic UI spec): https://purecode.ai/community/jarvisui-tailwind-jarvisui

[^382^]: OpenReplay — Creating Holographic Effects in CSS: https://blog.openreplay.com/creating-holographic-effects-css/

[^383^]: Wavespace Agency — Black and Orange Website Design Ideas 2026 (psychology): https://www.wavespace.agency/blog/black-and-orange-websites

[^385^]: Prismic — CSS Button Animations (glitch, hologram): https://prismic.io/blog/css-button-animations

[^398^]: PlayerAuctions — How to Change Class in Solo Leveling ARISE Overdrive: https://www.playerauctions.com/solo-leveling-arise-guide/tips-guides/how-to-change-class/

[^399^]: Solo Leveling Wiki — Red Gate (danger dungeon): https://solo-leveling.fandom.com/wiki/Red_Gate

[^400^]: ScreenRant — Solo Leveling: What Are the Red Gates: https://screenrant.com/solo-leveling-red-gates-explainer/

[^401^]: StableDiffusionWeb — Elegant Dark Fantasy Game UI: https://stablediffusionweb.com/image/27919365-elegant-dark-fantasy-game-ui

[^403^]: LifeTips — Best Alarm Clock Apps for Android & iOS: https://lifetips.alibaba.com/tech-efficiency/best-alarm-clock-apps-android-ios

[^404^]: YouTube — Danger! Red Gate! Solo Leveling Arise: https://www.youtube.com/watch?v=r2iHCx-V5VQ

[^406^]: Solo Leveling Wiki — Job Change Quest Dungeon: https://solo-leveling.fandom.com/wiki/Job_Change_Quest_Dungeon

[^407^]: Solo Leveling Wiki — Job Change Quest: https://solo-leveling.fandom.com/wiki/Job_Change_Quest
