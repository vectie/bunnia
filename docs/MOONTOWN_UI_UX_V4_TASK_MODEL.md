# Moontown V4 Page Task And Familiarity Model

This document defines what an ordinary user is trying to accomplish on every
Moontown page, how the task ends, which familiar app pattern carries it, and how
much product-specific learning is acceptable.

The goal is recognition before recall:

```text
standard app behavior should require no explanation
Moontown concepts may require one short encounter
reviewer operations may require deliberate training
```

## Global Navigation Contract

The five bottom tabs follow a common mobile-app model and stay stable:

| Tab | Familiar archetype | User question | Learning target |
| --- | --- | --- | --- |
| Home | activity dashboard | What needs me now? | under 5 seconds |
| Discover | search or marketplace | Where can I find something useful? | under 5 seconds |
| Realm | map or game world | Where is this place and what is nearby? | 30-60 seconds |
| Messages | chat inbox plus task inbox | Who replied, and what needs a decision? | under 10 seconds |
| My | profile plus personal library | What is mine and what can I manage? | 15-30 seconds |

Realm is the only intentionally novel primary tab. Home, Discover, Messages,
and My should use conventions users already know from consumer mobile apps.
Reviewer is not a primary tab because it is a trained operational surface.

## Home

**User job:** notice the highest-priority change and enter the right workflow.

**Primary flow:**

1. Read the single lead decision.
2. Use the three counts only to judge urgency.
3. Tap the lead action to continue in Messages, Realm, Discover, or My.
4. If nothing is urgent, scan Town Gates and enter a district.

**Done means:** the user has left Home for the page that owns the work. Home
does not complete reviews, publishing, placement, or profile setup itself.

**Familiar model:** notification center or personalized dashboard. Users already
expect one urgent item, compact counts, and shortcuts.

**Moontown learning:** Town Gates are branded shortcuts, but their destination
labels must remain ordinary verbs such as Browse, Review, or Verify.

**Recovery:** a stale or failed lead must offer one retry or destination action.
Do not expose backend state.

**Learning budget:** 5 seconds to identify the next action; no tutorial.

## Discover

**User job:** find one useful public person, circle, product, demand, event,
post, agent, book, or place.

**Primary flow:**

1. Enter a query or choose a familiar filter.
2. Scan title, type, and eligibility.
3. Tap the result's single explicit action.
4. Complete secondary operations after opening the destination.

**Done means:** the selected result is open. Placement belongs to the object's
lifecycle in Realm; subscriptions belong to Messages.

**Familiar model:** marketplace or universal search. Search, horizontal filter
chips, vertical results, and one dominant result action should be immediately
recognizable.

**Moontown learning:** eligibility labels such as Can place explain town rules
without asking users to understand publication or placement internals.

**Recovery:** an empty result gives one instruction to change query or filter.

**Learning budget:** 5 seconds; one search should be possible without help.

## Realm

**User job:** locate a place, inspect it, and enter its contextual workflow.

**Primary flow:**

1. Scan or pan the map and select a marker.
2. Read the selected place name and status.
3. Use Ask as the dominant action.
4. Use Messages or Find Similar when the task belongs elsewhere.
5. Use the lifecycle section for placement or owner operations.

**Done means:** the user has asked the place, entered its messages, found a
similar place, or completed a lifecycle action.

**Familiar model:** map app combined with a game-world inspector. Marker
selection and a bottom/right detail sheet are familiar; books, agents, and town
lifecycle are product-specific.

**Moontown learning:** users need to learn that buildings own books, agents,
messages, and placement. The selected drawer must teach this through structure,
not an instruction paragraph.

**Recovery:** the map stays visible, selection remains stable, and the drawer
has a clear route back through the standard tab bar.

**Learning budget:** 30-60 seconds during the first visit; no recurring tutorial.

## Messages

**User job:** catch up with conversations and complete work that arrived through
them.

**Primary flow:**

1. Scan Chats using avatar, title, one-line preview, and unread state.
2. Use All, Unread, Replies, Activity, or Notices to narrow the list.
3. Tap a row to open the conversation's destination.
4. Continue to the priority lead, Needs Review, or Agent Work below Chats for operational
   decisions.

**Done means:** the conversation is opened or acknowledged, or its associated
review/run action is completed.

**Familiar model:** mobile messenger inbox. The expected order is conversation
list first, then secondary task sections. The whole conversation row is the tap
target and uses an avatar-like identifier, sender/title, preview, and unread
dot. There are no repeated Open or Mark Read buttons to learn.

**Do not imitate:** fake timestamps, fake people, or speech bubbles for system
events. Moontown Messages includes people, agents, reviews, and system notices,
so the familiar pattern is the inbox list, not a fabricated one-to-one chat.

**Recovery:** unread state remains explicit; failed work appears below with a
Try Again action only when retry is actually available.

**Learning budget:** under 10 seconds. Users may need to learn what Agent means,
but not how to scan or filter the inbox.

## My

**User job:** finish identity requirements, then manage owned work.

**Primary flow:**

1. Read identity and the single highest-priority setup task.
2. Complete pending passport gates.
3. Filter My Inventory and open one owned item.
4. Check public identity and the current or blocking publishing stage.
5. Enter Reviewer Tools only through the deliberate gate.

**Done means:** setup is complete, an owned object is open, a publication
blocker is understood, or a reviewer intentionally enters operations.

**Familiar model:** profile plus personal library. Identity first, owned items
second, settings and advanced tools later.

**Moontown learning:** passport and publishing lifecycle are branded domain
concepts. Completed setup and full historical timelines should not compete with
the current task.

**Recovery:** blockers explain the missing user action; refresh is available for
owned work without exposing cache or endpoint language.

**Learning budget:** 15-30 seconds because publishing is domain-specific.

## Reviewer

**User job:** inspect launch readiness, moderation, and backend operations with
high confidence.

**Primary flow:**

1. Enter through Reviewer Tools.
2. Identify the operational section.
3. Inspect evidence and state.
4. Take the explicit review or moderation action.
5. Return to My.

**Done means:** a decision or inspection is recorded and the operator can trace
what changed.

**Familiar model:** admin console, not a consumer page. Higher density is
acceptable when labels, grouping, and auditability are strong.

**Learning budget:** trained use; first-use self-discovery is not a requirement.

## Cross-Page Handoffs

Each task has one owning page:

| Starting page | Handoff | Owning page |
| --- | --- | --- |
| Home | review or reply | Messages |
| Home | find public object | Discover |
| Home | inspect place | Realm |
| Home | finish identity | My |
| Discover | open place | Realm |
| Realm | continue conversation | Messages |
| Messages | inspect place | Realm |
| Messages | complete review/run | Messages task sections |
| My | inspect owned place | Realm |
| My | review books or agents | Messages |

Pages should route to the owner instead of embedding a second copy of the same
workflow.

## Acceptance Tests

An untrained user should be able to:

- name the purpose of Home, Discover, Messages, and My within 5 seconds each
- find and open a Discover result without instruction
- distinguish unread and read message rows without relying only on color
- reach a review from Home or Messages in no more than two primary taps
- reach an owned place from My in no more than two primary taps
- select a Realm marker and identify Ask as the primary action
- return through the stable five-tab navigation without losing orientation

Realm may take one exploratory minute. Reviewer may require training. No other
ordinary page should require users to memorize Moontown-specific interaction.

## Implemented V4.5 Evidence

Messages now opens directly on the familiar list rather than a task card. The
list uses five conventional filters, seven 51px rows, one-line previews, and
unread presence dots. Rows contain no nested action buttons; opening the row is
the action. The priority lead and operational queues remain below the list.

On the iPhone 12/13 Pro simulator, Chats begins at 83px, the last row ends at
546px, and the priority lead begins at 561px. A first-time user can therefore
scan the complete inbox before encountering Moontown-specific review and agent
work concepts.
