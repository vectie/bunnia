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
