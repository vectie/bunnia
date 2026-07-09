///|
pub fn open_reviewer_tools(
  projection : MiniTownProjection,
) -> MiniTownProjection {
  { ..projection, reviewer_tools_open: true }
}

///|
pub fn close_reviewer_tools(
  projection : MiniTownProjection,
) -> MiniTownProjection {
  { ..projection, reviewer_tools_open: false }
}
