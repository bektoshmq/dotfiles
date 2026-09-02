# Herdr work items

## Show positional numbers on named tabs

- [ ] Render every tab label as `<position>:<name>` when the tab has a custom
  name, while leaving unnamed tabs as `<position>`.

Examples: `1:codex`, `2:server`, `3:logs`.

The number must be the tab's current one-based position, matching the
`Alt+1..9` and `prefix+1..9` bindings. It should update when tabs are moved or
closed; do not use Herdr's stable public tab ID, which can contain gaps.

Herdr currently chooses either the custom name or `tab_idx + 1`. The relevant
code is `tab_chrome_label` in `src/ui/tabs.rs`, backed by `tab_display_name` in
`src/workspace.rs`. There is no configuration option for displaying both, so
this requires an upstream change or a maintained patch and custom rebuild of
Omarchy's Herdr fork.

Acceptance criteria:

- Named tabs always show their current positional number and custom name.
- Unnamed tabs continue to show only their current positional number.
- Moving or closing tabs immediately renumbers the displayed positions.
- Direct numbered tab bindings select the tab bearing the same displayed
  number.
- Zoom and active/inactive tab indicators remain unchanged.
- The customization has a documented reapplication path after package updates,
  unless it is accepted upstream.
