defmodule AshDemoWeb.UsersLiveView do
  use AshDemoWeb, :live_view
  import Phoenix.HTML.Form
  alias AshDemo.Account.User

  def render(assigns) do
    ~H"""
    <h2>Users List</h2>
    <div>
    <%= for user <- @users do %>
      <div>
        <div><%= user.name %> <%= user.created_at %></div>
        <button phx-click="delete_user" phx-value-user-id={user.id}>delete</button>
      </div>
    <% end %>
    </div>
    <h2>Create User</h2>
    <.form :let={f} for={@create_form} phx-submit="create_user">
      <%= text_input f, :name, placeholder: "input name" %>
      <%= submit "create" %>
    </.form>
    """
  end

  def mount(_params, _session, socket) do
    users = User.read_all!()

    socket =
      assign(socket,
        users: users,
        user_selector: user_selector(users),
        # the `to_form/1` calls below are for liveview 0.18.12+. For earlier versions, remove those calls
        create_form: AshPhoenix.Form.for_create(User, :create) |> to_form(),
        update_form: AshPhoenix.Form.for_update(List.first(users, %User{}), :update) |> to_form()
      )

    {:ok, socket}
  end

  def handle_event("delete_user", %{"user-id" => user_id}, socket) do
    user_id |> User.get_by_id!() |> User.destroy!()
    users = User.read_all!()

    {:noreply, assign(socket, users: users, user_selector: user_selector(users))}
  end

  def handle_event("create_user", %{"form" => %{"name" => name}}, socket) do
    User.create(%{name: name})
    users = User.read_all!()

    {:noreply, assign(socket, users: users, user_selector: user_selector(users))}
  end



  defp user_selector(users) do
    for user <- users do
      {user.name, user.id}
    end
  end
end
