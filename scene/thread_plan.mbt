///|
pub struct SceneThreadBudget {
  max_visible_links : Int
  max_unread_total : Int
  max_orphan_links : Int
  max_links_without_open_message : Int
} derive(Debug, Eq)

///|
pub struct SceneThreadPlan {
  scene_id : String
  total_link_count : Int
  visible_link_count : Int
  hidden_link_count : Int
  unread_total : Int
  links_with_unread_count : Int
  orphan_link_count : Int
  links_without_open_message_count : Int
  diagnostics : Array[String]
  summary : String
} derive(Debug, Eq)

///|
pub fn scene_thread_budget(
  max_visible_links? : Int = 80,
  max_unread_total? : Int = 999,
  max_orphan_links? : Int = 0,
  max_links_without_open_message? : Int = 0,
) -> SceneThreadBudget {
  {
    max_visible_links,
    max_unread_total,
    max_orphan_links,
    max_links_without_open_message,
  }
}

///|
pub fn default_scene_thread_budget() -> SceneThreadBudget {
  scene_thread_budget()
}

///|
pub fn plan_scene_threads(
  input : Scene,
  links : Array[SceneThreadLink],
) -> SceneThreadPlan {
  plan_scene_threads_with_budget(input, links, default_scene_thread_budget())
}

///|
pub fn plan_scene_threads_with_budget(
  input : Scene,
  links : Array[SceneThreadLink],
  budget : SceneThreadBudget,
) -> SceneThreadPlan {
  let visible_link_count = clamp_visible_count(
    links.length(),
    budget.max_visible_links,
  )
  let unread_total = scene_thread_unread_total(links)
  let links_with_unread_count = scene_thread_links_with_unread_count(links)
  let orphan_link_count = scene_thread_orphan_link_count(input, links)
  let links_without_open_message_count = scene_thread_links_without_open_message_count(
    links,
  )
  let diagnostics = scene_thread_diagnostics(
    link_count=links.length(),
    visible_link_count~,
    unread_total~,
    orphan_link_count~,
    links_without_open_message_count~,
    budget~,
  )
  {
    scene_id: input.id,
    total_link_count: links.length(),
    visible_link_count,
    hidden_link_count: links.length() - visible_link_count,
    unread_total,
    links_with_unread_count,
    orphan_link_count,
    links_without_open_message_count,
    diagnostics,
    summary: "Bunnia scene thread plan: scene=\{input.id} links=\{visible_link_count}/\{links.length()} hidden=\{links.length() - visible_link_count} unread_total=\{unread_total} links_with_unread=\{links_with_unread_count} orphan_links=\{orphan_link_count} links_without_open_message=\{links_without_open_message_count} diagnostics=\{diagnostics.length()}",
  }
}

///|
fn scene_thread_diagnostics(
  link_count~ : Int,
  visible_link_count~ : Int,
  unread_total~ : Int,
  orphan_link_count~ : Int,
  links_without_open_message_count~ : Int,
  budget~ : SceneThreadBudget,
) -> Array[String] {
  let diagnostics : Array[String] = []
  if visible_link_count < link_count {
    diagnostics.push(
      "scene-thread-links-over-budget:\{link_count}/\{budget.max_visible_links}",
    )
  }
  if unread_total > budget.max_unread_total {
    diagnostics.push(
      "scene-thread-unread-over-budget:\{unread_total}/\{budget.max_unread_total}",
    )
  }
  if orphan_link_count > budget.max_orphan_links {
    diagnostics.push(
      "scene-thread-orphan-links:\{orphan_link_count}/\{budget.max_orphan_links}",
    )
  }
  if links_without_open_message_count > budget.max_links_without_open_message {
    diagnostics.push(
      "scene-thread-links-without-open-message:\{links_without_open_message_count}/\{budget.max_links_without_open_message}",
    )
  }
  diagnostics
}

///|
fn clamp_visible_count(total : Int, max_visible_count : Int) -> Int {
  if max_visible_count < 0 {
    0
  } else if max_visible_count < total {
    max_visible_count
  } else {
    total
  }
}

///|
fn scene_thread_unread_total(links : Array[SceneThreadLink]) -> Int {
  let mut total = 0
  for link in links {
    total += link.unread_count
  }
  total
}

///|
fn scene_thread_links_with_unread_count(links : Array[SceneThreadLink]) -> Int {
  let mut count = 0
  for link in links {
    if link.unread_count > 0 {
      count += 1
    }
  }
  count
}

///|
fn scene_thread_links_without_open_message_count(
  links : Array[SceneThreadLink],
) -> Int {
  let mut count = 0
  for link in links {
    if link.open_message == "" {
      count += 1
    }
  }
  count
}

///|
fn scene_thread_orphan_link_count(
  input : Scene,
  links : Array[SceneThreadLink],
) -> Int {
  let mut count = 0
  for link in links {
    if link.scene_id != input.id || !scene_has_marker(input, link.marker_id) {
      count += 1
    }
  }
  count
}

///|
fn scene_has_marker(input : Scene, marker_id : String) -> Bool {
  for scene_layer in input.layers {
    for scene_marker in scene_layer.markers {
      if scene_marker.id == marker_id {
        return true
      }
    }
  }
  false
}
