# Moontown V5 UI/UX Test Report

Date: 2026-07-13

Plan: `docs/MOONTOWN_UI_UX_V5_PLAN.md`

## Decision

**V5 first-viewport signoff passes on iPhone 12/13 Pro.** All route contracts,
MoonBit tests, strict build gates, and the live WeChat compile pass. No WXML,
application, or runtime error was observed.

The remaining release check is a complete journey sweep on both the smallest
and largest supported phone profiles. That check is continuous device coverage,
not a known V5 product blocker.

## Method

Testing followed the user-task oracle established in V4:

1. identify what appears first
2. justify why it belongs there
3. identify the action a user can take
4. predict the action a user will normally take
5. define the visible or persisted outcome
6. verify that the outcome is achievable without implementation knowledge

Evidence was collected in two passes. Static and automated checks verified
generated route structure, state patches, typography floors, privacy, build
budgets, and handoff contracts. Live WeChat DevTools review then checked the
actual first viewport, navigation, Discover disclosure, Realm disclosure,
safe-area ownership, and debugger output.

## Environment

- repository: `vectie/bunnia`
- target: WeChat mini-program
- simulator: iPhone 12/13 (Pro), 93%
- WeChat DevTools: Stable 2.01.2510290
- WeChatLib: 3.16.2
- generated project: `_build/bunnia/wechat/moontown_miniapp`
- MoonBit tests: 236/236 passed
- focused Moontown tests: 27/27 passed
- strict build: 182,136 bytes, 8/8 ready, 0 diagnostics
- first-screen maximum: 75,684 bytes
- max update payload: 2,844 bytes
- event patch operations: 151
- live debugger: 0 errors, 2 platform notices

The two notices are the WeChatLib gray-release notice and the platform guidance
for `getSystemInfo`; neither is an application failure.

## Page Oracle

| Page | User sees and why | User does | Expected and observed outcome |
| --- | --- | --- | --- |
| Home | One decision lead, three counts, three Town Gates, then nearby people. This answers "what needs me now?" before general navigation. | Reviews the lead or enters Product Market, Demand Hall, or Town Trust. | One obvious first action and at most three peer destinations are visible; route contracts and live first viewport pass. |
| Discover | Search, All/Places/People/More, then compact public rows. This follows familiar search and catalog interfaces. | Searches, chooses a broad type, or opens More for the full taxonomy. | Four choices remain visible by default; More opens eight secondary categories and Close; rows keep one trailing action. Live interaction passes. |
| Realm | Terrain first, one selected marker, and a compact place sheet. Spatial orientation must precede place administration. | Asks directly or opens Details for messages, related places, memory, workers, lifecycle, and communication. | The compact sheet preserves most of the map; Details expands to a bounded scrollable drawer and Back to map is available. Live interaction passes. |
| Messages | Chats, refresh, familiar channel filters, avatar rows, previews, and unread dots; work queues follow below. This matches common inbox scanning. | Opens a conversation, filters the inbox, or continues to review and agent tasks. | Conversation rows are readable and distinct from task sections; the native title and fixed tabs remain stable. Live first viewport passes. |
| My | One identity/readiness block, one attention item, then My Inventory. Public identity and publishing are secondary. | Resolves the alert, filters owned items, or opens a place; later manages public and publishing state. | Identity appears once and inventory precedes Public Passport and Publishing Shelf. The ordinary surface now fills the safe area behind navigation. Live first viewport passes. |
| Reviewer | A separate credentialed diagnostic route. It is intentionally outside ordinary five-tab work. | Opens reviewer tools from My when authorized. | Route remains generated and covered by existing reviewer contracts; it does not add noise to ordinary routes. Automated contract passes. |

## Acceptance Results

- PASS: ordinary routes use only the native page title
- PASS: ordinary body text is at least `26rpx`; secondary and tab text is at
  least `22rpx`
- PASS: dense ordinary content sits on opaque neutral surfaces
- PASS: Realm remains map-led and details require explicit disclosure
- PASS: Home has one lead and three first-level destinations
- PASS: Discover exposes four primary choices
- PASS: Messages keeps whole-row inbox structure and unread cues
- PASS: My shows identity once and inventory before publishing history
- PASS: all six routes build with zero diagnostics and zero live debugger errors
- PENDING CONTINUOUS GATE: repeat complete scroll and cross-page journeys on
  the smallest and largest supported phone profiles

## Residual Risk

The live pass exercised route switching, Discover More, Realm Details, and the
ordinary-page safe area. It did not repeat every persistence-changing V4
journey on both device extremes. Those behaviors remain covered by generated
contracts, runtime patch tests, backend tests, and the V4 end-to-end evidence,
but should still be included in pre-release device regression.
