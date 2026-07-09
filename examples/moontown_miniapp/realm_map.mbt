///|
// Realm map assembly stays map-first; backdrop, markers, and HUD live beside it.

///|
fn town_map_surface(projection : MiniTownProjection) -> @bunnia.Node {
  let scene = demo_scene()
  let camera = demo_camera()
  let camera_plan = @bunnia.plan_scene_camera(scene, camera)
  let thread_links = demo_scene_thread_links(projection)
  @bunnia.view_with_attrs([@bunnia.class_name("moontown-map-fullscreen")], [
    @bunnia.view_with_attrs(
      [
        @bunnia.class_name("moontown-map-touch-area"),
        @bunnia.attr("bindtouchstart", "onMoontownMapTouchStart"),
        @bunnia.attr("catchtouchmove", "onMoontownMapTouchMove"),
        @bunnia.attr("bindtouchend", "onMoontownMapTouchEnd"),
        @bunnia.attr("bindtouchcancel", "onMoontownMapTouchEnd"),
      ],
      [
        @bunnia.view_with_attrs(
          [
            @bunnia.class_name("moontown-map-drag-content"),
            @bunnia.attr("style", "{{mapViewport.style}}"),
          ],
          [moontown_map_image(), map_markers(projection)],
        ),
      ],
    ),
    @bunnia.view_with_attrs([@bunnia.class_name("moontown-semantic-scene")], [
      @bunnia.static_scene_view_with_camera(scene, camera),
      @bunnia.windowed_anchored_scene_thread_overlay_with_viewport(
        scene,
        camera_plan.viewport,
        thread_links,
        total_count=thread_links.length(),
      ),
    ]),
  ])
}
