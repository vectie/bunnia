///|
fn moontown_wxss() -> String {
  minify_moontown_wxss(moontown_wxss_source())
}

///|
fn moontown_wxss_for_tab(tab_id : String) -> String {
  if tab_id == "reviewer" {
    reviewer_wxss()
  } else {
    moontown_wxss()
  }
}

///|
fn reviewer_wxss() -> String {
  minify_moontown_wxss(reviewer_wxss_source())
}

///|
fn minify_moontown_wxss(css : String) -> String {
  css
  .replace_all(old="\n", new="")
  .replace_all(old=" + ", new="+")
  .replace_all(old=" - ", new="-")
  .replace_all(old=" {", new="{")
  .replace_all(old="{ ", new="{")
  .replace_all(old="; ", new=";")
  .replace_all(old=": ", new=":")
  .replace_all(old=", ", new=",")
  .replace_all(old=" }", new="}")
  .replace_all(old=";}", new="}")
  .replace_all(old=" > ", new=">")
}
