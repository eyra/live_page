defmodule LiveNest.EventTest do
  @moduledoc """
  Integration test for event propagation.
  """

  use LiveNest.Support.ConnCase, async: false

  test "event from modal to widget and page", %{conn: conn} do
    {:ok, page, _html} = live(conn, "/dashboard")

    dashboard = find_live_child(page, "dashboard") 
    data_widget = find_live_child(dashboard, "data-widget") 
    data_widget |> render_click("settings")
    # wait for the modal to be displayed
    Process.sleep(1)
    html = page |> render()
    assert html =~ "Data settings"
    refute html =~ "Settings updated"
    assert page |> has_element?("#total-users")
    assert page |> has_element?("#active-users")
    assert page |> has_element?("#new-users")
    

    page |> element("#data-form form") |> render_change(%{
        show_total: false,
        show_active: true,
        show_new: true
    })

    data_widget |> render()
    assert page |> render() =~ "Settings updated"
    refute page |> has_element?("#total-users")
    assert page |> has_element?("#active-users")
    assert page |> has_element?("#new-users")

  end
end