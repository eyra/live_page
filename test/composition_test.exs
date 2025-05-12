defmodule LiveNest.CompositionTest do
  @moduledoc """
  Integration test for the composition of nested live views.
  """

  use LiveNest.Support.ConnCase, async: true

  import Phoenix.LiveViewTest

  test "displays the dashboard page", %{conn: conn} do
    {:ok, page, _html} = live(conn, "/dashboard")

    header = find_live_child(page, "header") 
    dashboard = find_live_child(page, "dashboard") 
    data_widget = find_live_child(dashboard, "data-widget") 
    chart_widget = find_live_child(dashboard, "chart-widget") 

    refute is_nil(header)
    refute is_nil(dashboard)
    refute is_nil(data_widget)
    refute is_nil(chart_widget)

    assert header |> render() =~ "Dashboard"
    assert data_widget |> render() =~ "User Stats"
    assert chart_widget |> render() =~ "Activity Chart"
  end
end