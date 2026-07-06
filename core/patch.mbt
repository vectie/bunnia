///|
pub(all) enum PatchKind {
  Set
  Append
  Remove
} derive(Debug, Eq)

///|
pub struct Patch {
  kind : PatchKind
  path : String
  value_json : String
  estimated_bytes : Int
} derive(Debug, Eq)

///|
pub struct PatchBudget {
  max_patches : Int
  max_patch_bytes : Int
} derive(Debug, Eq)

///|
pub struct PatchPlan {
  patches : Array[Patch]
  total_estimated_bytes : Int
  diagnostics : Array[String]
  summary : String
} derive(Debug, Eq)

///|
pub fn patch_budget(max_patches~ : Int, max_patch_bytes~ : Int) -> PatchBudget {
  { max_patches, max_patch_bytes }
}

///|
pub fn default_patch_budget() -> PatchBudget {
  { max_patches: 64, max_patch_bytes: 8192 }
}

///|
pub fn set_json(path : String, value_json : String) -> Patch {
  patch(kind=Set, path~, value_json~)
}

///|
pub fn set_string(path : String, value : String) -> Patch {
  set_json(path, "\"\{escape_json(value)}\"")
}

///|
pub fn append_json(path : String, value_json : String) -> Patch {
  patch(kind=Append, path~, value_json~)
}

///|
pub fn remove_path(path : String) -> Patch {
  patch(kind=Remove, path~, value_json="null")
}

///|
pub fn plan_patches(patches : Array[Patch]) -> PatchPlan {
  plan_patches_with_budget(patches, default_patch_budget())
}

///|
pub fn plan_patches_with_budget(
  patches : Array[Patch],
  budget : PatchBudget,
) -> PatchPlan {
  let diagnostics : Array[String] = []
  let mut total = 0
  for item in patches {
    total += item.estimated_bytes
  }
  if patches.length() > budget.max_patches {
    diagnostics.push(
      "patch-count-over-budget:\{patches.length()}/\{budget.max_patches}",
    )
  }
  if total > budget.max_patch_bytes {
    diagnostics.push(
      "patch-bytes-over-budget:\{total}/\{budget.max_patch_bytes}",
    )
  }
  {
    patches,
    total_estimated_bytes: total,
    diagnostics,
    summary: "Bunnia patch plan: patches=\{patches.length()} bytes=\{total} diagnostics=\{diagnostics.length()}",
  }
}

///|
fn patch(kind~ : PatchKind, path~ : String, value_json~ : String) -> Patch {
  {
    kind,
    path,
    value_json,
    estimated_bytes: path.length() + value_json.length(),
  }
}

///|
fn escape_json(value : String) -> String {
  value
  .replace(old="\\", new="\\\\")
  .replace(old="\"", new="\\\"")
  .replace(old="\n", new="\\n")
  .to_string()
}
