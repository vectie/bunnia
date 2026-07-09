///|
pub fn demo_view() -> @bunnia.Node {
  mini_town_view(demo_projection())
}

///|
pub fn mini_town_view(projection : MiniTownProjection) -> @bunnia.Node {
  mini_town_view_with_map_mode(projection, full_map=true)
}

///|
fn mini_town_route_view(projection : MiniTownProjection) -> @bunnia.Node {
  mini_town_view_with_map_mode(
    projection,
    full_map=projection.active_tab_id == "realm",
  )
}

///|
fn mini_town_view_with_map_mode(
  projection : MiniTownProjection,
  full_map~ : Bool,
) -> @bunnia.Node {
  @bunnia.page([
    @bunnia.view_with_attrs(
      [
        @bunnia.class_name("moontown-miniapp"),
        @bunnia.data("active-user", projection.active_user_id),
      ],
      [
        if full_map {
          town_map_surface(projection)
        } else {
          town_map_backdrop(projection)
        },
        town_top_bar(projection),
        town_active_surface(projection),
        town_tabbar(projection),
      ],
    ),
  ])
}

///|
pub fn demo_wechat_page() -> @bunnia.WechatPage {
  let page = @bunnia.generate_wechat_page_with_runtime(
    "Moontown Miniapp",
    demo_view(),
    demo_runtime(),
  )
  @bunnia.wechat_page_with_wxss(page, page.wxss + "\n" + moontown_wxss())
}

///|
pub fn demo_wechat_project() -> @bunnia.WechatProject {
  demo_wechat_project_with_render_budget(@bunnia.default_render_budget())
}

///|
pub fn demo_wechat_project_with_render_budget(
  render_budget : @bunnia.RenderBudget,
) -> @bunnia.WechatProject {
  @bunnia.generate_wechat_project_from_pages_with_backend(
    name="Moontown Miniapp",
    pages=demo_wechat_project_pages(render_budget),
    backend_contract=demo_backend_contract(),
  )
}

///|
fn demo_wechat_project_pages(
  render_budget : @bunnia.RenderBudget,
) -> Array[@bunnia.WechatProjectPage] {
  let pages : Array[@bunnia.WechatProjectPage] = []
  for tab_id in ["realm", "home", "discover", "messages", "my", "reviewer"] {
    pages.push(demo_wechat_project_page_for_tab(tab_id, render_budget))
  }
  pages
}

///|
fn demo_wechat_project_page_for_tab(
  tab_id : String,
  render_budget : @bunnia.RenderBudget,
) -> @bunnia.WechatProjectPage {
  let page = @bunnia.wechat_project_page(
    name=moontown_tab_page_name(tab_id),
    route=moontown_tab_route(tab_id),
    root=moontown_project_tab_root(tab_id),
    runtime=demo_runtime_for_tab(tab_id),
    render_budget~,
  )
  scoped_project_page_runtime(
    @bunnia.wechat_project_page_with_wxss(page, moontown_wxss_for_tab(tab_id)),
  )
}

///|
fn moontown_project_tab_root(tab_id : String) -> @bunnia.Node {
  if tab_id == "reviewer" {
    reviewer_route_view(
      open_reviewer_tools(switch_tab(demo_projection(), "my")),
    )
  } else {
    mini_town_route_view(switch_tab(demo_projection(), tab_id))
  }
}

///|
fn reviewer_route_view(projection : MiniTownProjection) -> @bunnia.Node {
  @bunnia.page([
    @bunnia.view_with_attrs(
      [
        @bunnia.class_name("moontown-miniapp"),
        @bunnia.data("reviewer-route", "true"),
      ],
      [
        @bunnia.view_with_attrs(
          [
            @bunnia.class_name("moontown-page-surface"),
            @bunnia.data("active-tab", "reviewer"),
          ],
          [operations_desk_panel(projection), reviewer_tools_back_button()],
        ),
      ],
    ),
  ])
}

///|
fn scoped_project_page_runtime(
  page : @bunnia.WechatProjectPage,
) -> @bunnia.WechatProjectPage {
  let runtime = @bunnia.wechat_runtime(
    initial_data_json=page.runtime.initial_data_json,
    event_patches=scoped_event_patches(
      page.runtime.event_patches,
      page.page.plan.event_messages,
    ),
    page_methods_js=page.runtime.page_methods_js,
  )
  @bunnia.wechat_project_page_with_runtime(page, runtime)
}

///|
fn scoped_event_patches(
  patches : Array[@bunnia.WechatEventPatch],
  messages : Array[String],
) -> Array[@bunnia.WechatEventPatch] {
  let output : Array[@bunnia.WechatEventPatch] = []
  for message in messages {
    output.push(scoped_event_patch(patches, message))
  }
  output
}

///|
fn scoped_event_patch(
  patches : Array[@bunnia.WechatEventPatch],
  message : String,
) -> @bunnia.WechatEventPatch {
  for patch in patches {
    if patch.message == message {
      return patch
    }
  }
  @bunnia.wechat_event_patch(message, [])
}

///|
fn moontown_tab_page_name(tab_id : String) -> String {
  if tab_id == "home" {
    "Moontown Home"
  } else if tab_id == "discover" {
    "Moontown Discover"
  } else if tab_id == "messages" {
    "Moontown Messages"
  } else if tab_id == "my" {
    "Moontown My"
  } else if tab_id == "reviewer" {
    "Moontown Reviewer"
  } else {
    "Moontown Realm"
  }
}

///|
fn moontown_tab_route(tab_id : String) -> String {
  if tab_id == "home" {
    "pages/moontown/home"
  } else if tab_id == "discover" {
    "pages/moontown/discover"
  } else if tab_id == "messages" {
    "pages/moontown/messages"
  } else if tab_id == "my" {
    "pages/moontown/my"
  } else if tab_id == "reviewer" {
    "pages/moontown/reviewer"
  } else {
    "pages/moontown/index"
  }
}

///|
