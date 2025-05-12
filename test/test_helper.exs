ExUnit.start()

# Configure the test endpoint
Application.put_all_env([
  live_nest: [
    {LiveNest.Support.TestEndpoint, [
        url: [host: "localhost"],
        http: [port: 4002],
        secret_key_base: String.duplicate("test", 8),
        server: true,
        live_view: [signing_salt: "test_signing_salt"],
        render_errors: [formats: [html: LiveNest.Support.TestErrorHTML], layout: false]
    ]}
  ]
])

Logger.configure(level: :info)

# Start Phoenix dependencies
Application.ensure_all_started(:phoenix)
Application.ensure_all_started(:phoenix_live_view)

# Start the live_nest application
Application.ensure_all_started(:live_nest)

# Start the test endpoint
{:ok, _} = LiveNest.Support.TestEndpoint.start_link()