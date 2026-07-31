# Moontown UI Guide

Moontown is a five-tab WeChat mini-app built in MoonBit with Bunnia.

## Main loop

1. Tap **Enter Town** once to create the local town session.
2. Use **Discover** to filter public results. Only controls with a complete
   destination are shown.
3. Open a place in **Realm**. The selected place must remain the same when
   navigating from Discover, Messages, or My.
4. Tap **Ask** to create agent work. The Realm drawer reports loading, success,
   or failure.
5. Tap **Place** on an eligible public building. The drawer reports **Placed**
   and removes the action so the same placement cannot be submitted twice.
6. Open **Messages** to review notices, agent work, and pending results. Review
   decisions and **Stop Work** remove the completed item from the pending list.
7. Use **My** for passport state, owned inventory, publishing work, Reviewer
   Tools, and the in-app **Town Guide**.

## Navigation

- **Home**: priority leads and shortcuts into the main loop.
- **Discover**: truthful result counts, accessible category filters, and public
  place entry.
- **Realm**: map, selected-place drawer, details, agent work, lifecycle, and
  safety reporting.
- **Messages**: chats, channels, review decisions, and work results.
- **My**: profile readiness, inventory, publishing, creation, reviewer entry,
  and this guide.

Exactly one bottom tab is active. When a place is opened from another page, its
identity is carried in the route and restored by Realm.

## State and recovery

Backend-backed controls show a visible loading, success, or failure message.
If a request fails, confirm the local backend is available, tap **Enter Town**
if the passport says **First visit**, and retry from the same control. Successful
refreshes use human-readable messages such as **Chats are up to date** and
**Your inventory is up to date**. When no item needs attention, My shows
**All Clear** rather than retaining a stale task count.

Reviewer diagnostics live only behind **My → Open Reviewer Tools**. Ordinary
town pages do not expose endpoint names, payload keys, or developer-only copy.
