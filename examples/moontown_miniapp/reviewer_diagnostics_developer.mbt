///|
fn developer_diagnostics_section(
  ops : MiniTownBackendStep,
  readiness : MiniTownBackendStep,
) -> @bunnia.Node {
  @bunnia.view_with_attrs(
    [
      @bunnia.class_name("moontown-diagnostic-section"),
      @bunnia.data("diagnostic-section", "developer"),
      @bunnia.data("developer-diagnostics", "local-explicit"),
      @bunnia.data("ops-endpoint", ops.endpoint_id),
      @bunnia.data("readiness-endpoint", readiness.endpoint_id),
    ],
    [
      @bunnia.view_with_attrs([@bunnia.class_name("mt-title")], [
        @bunnia.text("Developer Diagnostics"),
      ]),
      @bunnia.text(
        "Endpoint id, HTTP path, payload key, response key, package diagnostics, and render diagnostics stay visible only here.",
      ),
      diagnostic_contract_row(
        "Town Safety", ops, "adminOpsQuery", "adminOpsResult",
      ),
      diagnostic_contract_row(
        "Launch Checks", readiness, "adminReadinessQuery", "adminReadinessResult",
      ),
    ],
  )
}

///|
fn diagnostic_contract_row(
  label : String,
  step : MiniTownBackendStep,
  payload_key : String,
  response_key : String,
) -> @bunnia.Node {
  @bunnia.view_with_attrs(
    [
      @bunnia.class_name("moontown-diagnostic-row"),
      @bunnia.data("diagnostic-contract", step.id),
      @bunnia.data("endpoint-id", step.endpoint_id),
      @bunnia.data("http-method", step.http_method),
      @bunnia.data("http-path", step.path),
      @bunnia.data("payload-key", payload_key),
      @bunnia.data("response-key", response_key),
    ],
    [
      @bunnia.text(label),
      @bunnia.view_with_attrs([@bunnia.class_name("mt-meta")], [
        @bunnia.text(
          "\{step.endpoint_id} - \{step.http_method} \{step.path} - payload \{payload_key} - response \{response_key}",
        ),
      ]),
    ],
  )
}
