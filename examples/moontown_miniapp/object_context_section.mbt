///|
fn building_context_section(projection : MiniTownProjection) -> @bunnia.Node {
  let building = selected_building(projection)
  let messages = selected_building_messages(projection)
  let runs = selected_building_runs(projection)
  let cards = building_context_cards(projection, messages, runs)
  object_section(
    section_id="communication",
    title="Communication Context",
    note="Latest message, agent work, and review needs stay tied to this place.",
    extra_class="moontown-chat-drawer",
    children=[
      @bunnia.windowed_list(
        cards,
        total_count=cards.length(),
        render=building_context_card_entry,
      ),
      @bunnia.form("send-building-message", [
        @bunnia.input(
          name="chatDraft.body",
          value="Can it publish an agent?",
          input_message="edit-chat-draft",
        ),
        @bunnia.button("Send", "send-building-message"),
      ]),
      @bunnia.view_with_attrs([@bunnia.data("building-id", building.id)], [
        @bunnia.text("Open Messages to continue the building thread."),
      ]),
    ],
  )
}
