defmodule UndiOnlineWeb.Live.TypeaheadComponent do
  @moduledoc """
  Use the component like this:

      <.live_component
        id="my-select"
        module={UndiOnlineWeb.Live.TypeaheadComponent}
        search_function={fn phrase -> Posts.search_posts(phrase) end}
        result_formatter={fn post -> "\#{post.title} \#{post.author}" end}
        value_formatter={fn result -> post.id end}
        on_submit={&send_update(@myself, select: &1)}
        on_select={&send_update(@myself, select: &1)}
      />

  """
  use UndiOnlineWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div id={@id} class="relative">

      <.form
        for={@form}
        phx-target={@myself}
        phx-change="search"
        phx-submit="submit"
        phx-debounce="400">

        <.input
          field={@form[:phrase]}
          id={"#{@id}-input"}
          value={@search_phrase}
          type="text"
          label={@label}
          placeholder={@placeholder}
          autocomplete="off"
        />
      </.form>

      <.focus_wrap id={"#{@id}-results"}>
        <ul
          :if={@results != []}
          role="listbox"
          phx-window-keydown="set-focus"
          phx-target={@myself}
          class={[
            "max-h-80 scroll-pb-2 scroll-pt-11 overflow-y-auto py-4",
            "bg-white divide-y divide-gray-100 rounded-lg shadow dark:bg-gray-700"
          ]}>
          <li :for={{result, idx} <- Enum.with_index(@results)}
            phx-click="select"
            phx-value-idx={idx}
            phx-target={@myself}
            class={[
              "cursor-default select-none px-4 py-1.5 text-sm text-gray-700 dark:text-gray-200",
              "hover:bg-blue-600 dark:hover:bg-blue-700 hover:text-white dark:hover:text-white",
              idx == @current_focus && "bg-blue-600 dark:bg-blue-700 text-white dark:text-white"
            ]}
            tabindex="-1">
            <%= @result_formatter.(result) %>
          </li>
        </ul>
      </.focus_wrap>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    {
      :ok,
      socket
      |> assign(assigns)
      |> assign(:form, to_form(%{}, as: :search))
      |> assign_reset()
      |> assign_new(:label, fn -> nil end)
      |> assign_new(:placeholder, fn -> "Search..." end)
      |> assign_new(:help_text, fn -> nil end)
      |> assign_new(:search_function, fn -> (fn _phrase -> [] end) end)
      |> assign_new(:result_formatter, fn -> (fn result -> inspect(result) end) end)
      |> assign_new(:phrase_formatter, fn -> (fn result -> inspect(result) end) end)
      |> assign_new(:value_formatter, fn -> (fn result -> inspect(result) end) end)
      |> assign_new(:on_submit, fn -> (fn result -> notify_parent(result) end) end)
      |> assign_new(:on_select, fn -> (fn result -> notify_parent(result) end) end)
    }
  end

  defp assign_reset(socket) do
    socket
    |> assign(:results, [])
    |> assign(:current_focus, -1)
    |> assign(:search_phrase, "")
  end

  @impl true
  def handle_event("search", %{"search" => %{"phrase" => search_phrase}}, socket) do
    if String.length(search_phrase) > 2 do
      results =
        socket.assigns.search_function.(search_phrase)

      {:noreply, assign(socket, results: results, search_phrase: search_phrase)}
    else
      {:noreply, assign(socket, :search_phrase, search_phrase)}
    end
  end

  def handle_event("submit", _, socket) do
    if result = Enum.at(socket.assigns.results, socket.assigns.current_focus) do
      socket.assigns.on_submit.(result)
    end

    {:noreply, socket}
  end

  def handle_event("select", %{"idx" => "" <> idx}, socket) do
    current_focus = String.to_integer(idx)
    if result = Enum.at(socket.assigns.results, current_focus) do
      socket.assigns.on_select.(result)

      {
        :noreply,
        socket
        |> assign_reset()
        |> assign(:search_phrase, socket.assigns.phrase_formatter.(result))
      }
    else
      {:noreply, socket}
    end
  end

  def handle_event("reset", _, socket) do
    {:noreply, assign_reset(socket)}
  end

  def handle_event("set-focus", %{"key" => "ArrowUp"}, socket) do
    current_focus =
      Enum.max([(socket.assigns.current_focus - 1), 0])
    {:noreply, assign(socket, current_focus: current_focus)}
  end

  def handle_event("set-focus", %{"key" => "ArrowDown"}, socket) do
    current_focus =
      Enum.min([(socket.assigns.current_focus + 1), (length(socket.assigns.results) - 1)])
    {:noreply, assign(socket, current_focus: current_focus)}
  end

  def handle_event("set-focus", %{"key" => "Escape"}, socket) do
    {:noreply, assign_reset(socket)}
  end

  # FALLBACK FOR NON RELATED KEY STROKES
  def handle_event("set-focus", _, socket), do: {:noreply, socket}

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end