# LumenTray

Scandinavian glass calorie tray. Hunt a name, lift a barcode, seat a pane on First Light / Midday / Evening / Nibble.

- **Bundle:** `com.lumentray.glass`
- **Category:** Health & Fitness
- **OS:** iOS 17+, iPhone portrait
- **Language:** Swift 6.2, SwiftUI, MVC, camelCase
- **Deps:** none (no SPM, no CocoaPods, no Alamofire)

## Architecture

MVC. Models are value types (portion math, EAN, records). Controllers own JSON in Documents (`lumen_vault.json`) and Open Food Facts via `URLSession`. Views bind to `LumenStore`. Tab bar: Today / Eaten / Plan / Wish / Aims.

Speed twist: swipe-to-log on the local pane, slot shortcuts in the context menu, keyboard commands, App Shortcuts (“Hunt a food name”, “Scan a glass code”).

## Flow

Onboard → Today → Hunt or Scan → Card → Assign → Today or 7-day Plan. Wish rejects a duplicate SKU. Nibble is eaten-only.

## Open Food Facts

- Search: `https://world.openfoodfacts.org/cgi/search.pl`
- Product: `https://world.openfoodfacts.org/api/v2/product/{code}.json`
- User-Agent: `LumenTray/1.0 (iOS; glass diary; lumen.tray.glass@example.com)`

## Persistence

`Documents/lumen_vault.json`. Simulator plants a one-time demo day.

Default aims: 1680 kcal / 88 p / 172 c / 58 f.

## Camera

`NSCameraUsageDescription`: LumenTray lifts a food barcode through the glass pane so a slot can be filled.

## Build

```bash
cd LumenTray
xcodegen generate
xcodebuild -project LumenTray.xcodeproj -scheme LumenTray \
  -destination 'platform=iOS Simulator,name=iPhone 16' build
```

## Unique features

Swipe-to-log on the local pane, context-menu slot shortcuts, keyboard commands, App Shortcuts (“Hunt a food name”, “Scan a glass code”). Nibble is eaten-only. Plan horizon is 7 days.

## How it differs

Glass-tray MVC + SwiftUI tabs and a JSON vault. Gesture-first logging. Not an arcade, oak pantry, civic desk, watercolor kitchen, or pulse grid.

## Tests

`LumenTrayTests` — Given / When / Then for portion scale, EAN, day totals.

## AI assets (26)

Style lock: 3D glass, soft light, minimalist, pastel, teal `#2A6F6F`, no letters.

Prompts are also stored on each `Assets.xcassets/*/Contents.json` `info.comment`.

| Asset | Prompt |
| --- | --- |
| AppIcon | App icon, square, no text. 3D frosted glass breakfast tray from slightly above, pale Scandinavian linen, one teal-tinted glass cup #2A6F6F, pearlescent bowl, soft dawn light, minimalist pastel still life. |
| SplashGlassDawn | iPhone splash, no text. Tall frosted Scandinavian glass pane in morning mist, thin teal rim #2A6F6F, volumetric light, pastel linen fog, 3D glass, minimalist. |
| OnboardFirstLight | Onboarding, no text. Hands placing a frosted glass oat bowl onto a luminous glass tray at first dawn, Scandinavian kitchen, teal #2A6F6F rim only, linen and stone. |
| OnboardScanGlass | Onboarding, no text or readable codes. 3D glass prism over a pale tray, teal light ribbon #2A6F6F passing through like a scan, Scandinavian mist, pastel. |
| OnboardSlots | Onboarding, no text. Four frosted-glass dishes in a row on pale stone, dawn-to-dusk light left to right, teal #2A6F6F on last rim, 3D glass pastel. |
| OnboardAims | Onboarding, no text or digits. Hovering teal glass ring #2A6F6F above a blank frosted-glass ledger, morning light, pastel linen room. |
| EmptyTodayTray | Empty state, no text. Empty frosted glass serving tray on pale linen, tiny teal glass bead #2A6F6F, 3D glass, quiet centered. |
| EmptyEatenGlass | Empty state, no text. Two empty stacked frosted glass plates, pale stone, teal #2A6F6F edge highlight, 3D glass pastel. |
| EmptyWishShelf | Empty state, no text. Three empty frosted-glass cube shelves, one with faint teal #2A6F6F glow, linen, 3D glass. |
| SlotFirstLight | Slot icon, no text. Frosted glass tray with pale oat bowl in first dawn rays, teal #2A6F6F rim whisper, Scandinavian pastel. |
| SlotMidday | Slot icon, no text. Clear glass carafe and lemon glass disc on a pale plate, soft noon light, teal only as thin shadow. |
| SlotEvening | Slot icon, no text. Frosted glass bowl beside a small warm glass lamp, dusk pastel, teal #2A6F6F lamp glow. |
| SlotNibble | Slot icon, no text. Tiny glass nibble dish with one pale cloudberry-like fruit, night-soft light, teal #2A6F6F bead. |
| FoodOatMilk | Shelf food, no labels. Frosted glass bottle of oat milk, creamy white, teal #2A6F6F glass stopper, Scandinavian product render. |
| FoodRyeCrisp | Shelf food, no logos. Stack of thin Nordic rye crispbread on a frosted glass square, tiny teal crumb dish, linen. |
| FoodSmokedTrout | Shelf food, no text. Stylized smoked trout on a pale glass oval, elegant, teal herb pinch bowl, Scandinavian pastel. |
| FoodCloudberry | Shelf food, no text. Frosted glass jar of pale cloudberry yogurt, one amber berry, teal glass spoon, linen. |
| FoodDillCucumber | Shelf food, no text. Pale cucumber slices in a frosted glass boat with dill, teal #2A6F6F rim, pastel. |
| FoodBirchWater | Shelf food, no labels. Slim frosted glass bottle of birch water, condensation, teal glass cap, linen. |
| FoodLingonOat | Shelf food, no text. Glass bowl of oat porridge with lingonberries, teal napkin ring, Scandinavian soft light. |
| FoodGoatCheese | Shelf food, no text. Soft goat cheese on a frosted glass tile, pale herbs, teal glass knife, linen. |
| TextureFrostPane | Background texture, no objects. Frosted Scandinavian glass pane, inner glow, faint teal #2A6F6F refraction, abstract pastel. |
| TextureMistLinen | Background texture, no objects. Pale Scandinavian linen with glass sheen, morning light, tiny teal thread glints, abstract. |
| ChromeGlassPill | UI chrome, no text. 3D frosted-glass pill button, teal #2A6F6F inner glow, soft specular, linen backdrop. |
| ChromeSlotFrame | UI chrome, no text. Rounded rectangular frosted-glass slot bezel, empty center, teal #2A6F6F thin edge, pastel. |
| ChromeTealBezel | UI chrome, no text. Small 3D frosted glass disk / teal bezel #2A6F6F, jewel-like but minimal, pastel. |
