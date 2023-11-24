defmodule UndiOnlineWeb.Live.CommandPaletteLive do
  @moduledoc """
  This command pallette is a LiveView that is designed to be mounted
  in the layout.

  ```
  <%= live_render(
    (assigns[:conn] || assigns[:socket]),
    UndiOnlineWeb.Live.CommandPaletteLive,
    id: "command-palette-lv",
    session: %{"context" => "app"}) %>
  ```

  ## Context
  You can pass a context and that is by default "app" or "admin". The
  idea is that you can use the same LiveView code but return different
  result depending on if you are a user in the normal application or an
  admin in the admin area.

  ## Trigger
  The command pallete modal can be opened with keyboard shortcut or a LiveView.JS command
  that dispatches a show-event to the `#command-palette`

  ```
  <script src="https://unpkg.com/hotkeys-js/dist/hotkeys.min.js"></script>
  <script type="text/javascript">
    hotkeys('command+k, ctrl+k', (event, handler) => {
      event.preventDefault()
      const el = document.querySelector('#command-palette')
      liveSocket.execJS(el, el.dataset.show)
    });
    window.addEventListener('show', event => {
      event.preventDefault()
      const el = event.target
      console.log(el)
      liveSocket.execJS(el, el.dataset.show)
    })
  </script>

  ```

  """

  use UndiOnlineWeb, :live_view

  alias UndiOnlineWeb.CommandPalette
  alias UndiOnlineWeb.CommandPalette.Format
  alias UndiOnlineWeb.CommandPalette.Result

  @impl true
  def render(assigns) do
    ~H"""
    <div id="command-palette" data-show={JS.push("show")}>
      <div
        id={@id}
        phx-mounted={@show && show_and_focus(@id)}
        phx-remove={hide_and_reset(@id)}
        class="relative z-50 hidden"
      >
        <div id={"#{@id}-bg"} class="fixed bg-gray-900 bg-opacity-50 dark:bg-opacity-80 fixed inset-0 transition-opacity" aria-hidden="true" />
        <div
          :if={@show}
          class="fixed inset-0 overflow-y-auto"
          aria-labelledby={"#{@id}-title"}
          aria-describedby={"#{@id}-description"}
          role="dialog"
          aria-modal="true"
          tabindex="0"
        >
          <div class="flex min-h-full items-center justify-center">
            <div class="w-full max-w-3xl p-4 sm:p-6 lg:py-8">
              <.focus_wrap
                id={"#{@id}-container"}
                phx-mounted={@show && show_and_focus(@id)}
                phx-window-keydown={hide_and_reset(@id)}
                phx-key="escape"
                phx-click-away={hide_and_reset(@id)}
                class="relative bg-white rounded-lg shadow dark:bg-gray-700"
              >
                <.form
                  for={@form}
                  phx-change="search"
                  phx-submit="submit"
                  phx-debounce="400"
                  class="block relative border-b border-gray-300 dark:border-gray-600">
                  <.icon name="hero-magnifying-glass" class="pointer-events-none absolute left-4 top-3.5 h-5 w-5 text-gray-500 dark:text-gray-400" />
                  <input name="search_form[text]" type="text" id={"#{@id}-input"} class={[
                    "h-12 w-full border-0 bg-transparent pl-11 pr-4 focus:ring-0 sm:text-sm",
                    "text-gray-900 placeholder:text-gray-400 dark:placeholder-gray-400 dark:text-white"]}
                    placeholder="Search..." autocomplete="off" />
                </.form>

                <!-- Default state, show/hide based on command palette state -->
                <div :if={@results == []} class="px-6 py-14 text-center text-sm sm:px-14">
                  <.icon name="hero-globe-alt" class="h-12 w-12 mx-auto text-gray-500 dark:text-gray-400" />
                  <p class="mt-4 font-semibold text-gray-900 dark:text-white">Search pages and records</p>
                  <p class="mt-2 text-gray-500 dark:text-gray-400">Quickly access pages and records by running a global search.</p>
                </div>

                <ul
                  :if={@results != []}
                  role="listbox"
                  phx-window-keydown="set-focus"
                  class="max-h-80 scroll-pb-2 scroll-pt-11 overflow-y-auto py-4">

                  <%= for %Result{record: record, first_type: first_type, index: idx} <- @results do %>
                    <li :if={first_type} class="text-xs font-bold px-4 py-1 uppercase text-gray-900 dark:text-white">
                      <h3><%= Format.header(record) %></h3>
                    </li>

                    <li class={[
                        "cursor-default select-none px-4 py-1.5 text-sm leading-6 text-gray-500 dark:text-gray-400",
                        "hover:bg-blue-600 dark:hover:bg-blue-700 hover:text-white dark:hover:text-white",
                        idx == @current_focus && "bg-blue-600 dark:bg-blue-700 text-white dark:text-white"
                      ]} tabindex="-1">

                      <.link href={Format.link(record)} class="space-x-1 block w-full">
                        <.formatted_and_normalized_label record={record} />
                      </.link>
                    </li>
                  <% end %>
                </ul>
              </.focus_wrap>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end

  attr :record, :any
  defp formatted_and_normalized_label(%{record: record} = assigns) do
    label_as_list =
      [Format.label(record)]
      |> List.flatten()
      |> Enum.with_index()

    assigns =
      assigns
      |> assign(:label_as_list, label_as_list)

    ~H"""
    <span
      :for={{part, i} <- @label_as_list}
      class={[i == 0 && "font-semibold"]}>
      <%= part %>
    </span>
    """
  end

  defp hide_and_reset(id) do
    hide_modal(id)
    |> JS.push("reset")
  end

  defp show_and_focus(id) do
    show_modal(id)
    |> JS.focus(to: "##{id}-input")
  end

  @impl true
  def mount(_params, session, socket) do
    {
      :ok,
      socket
      |> assign(:id, "command-palette-modal")
      |> assign(:show, false)
      |> assign(:context, Map.get(session, "context", "app"))
      |> assign(:account_id, Map.get(session, "curent_account_id"))
      |> assign(:form, to_form(%{}, as: :search_form))
      |> assign(:results, [])
      |> assign(:search_phrase, "")
      |> assign(:current_focus, -1)
    }
  end

  @impl true
  def handle_event("show", _, socket) do
    {
      :noreply,
      socket
      |> assign(:show, true)
      |> push_event("js-exec", %{
        to: "##{socket.assigns.id}",
        attr: "phx-mounted"
      })
    }
  end

  def handle_event("reset", _, socket) do
    {
      :noreply,
      socket
      |> assign(:show, false)
      |> assign(:results, [])
      |> assign(:search_phrase, "")
      |> assign(:current_focus, -1)
    }
  end

  @impl true
  def handle_event("search", %{"search_form" => %{"text" => text}}, socket) do
    results = CommandPalette.search(text, context: socket.assigns.context)

    {
      :noreply,
      socket
      |> assign(:search_phrase, text)
      |> assign(:results, results)
    }
  end

  def handle_event("submit", _, socket) do
    case Enum.at(socket.assigns.results, socket.assigns.current_focus) do
      %Result{record: record} ->
        {:noreply, push_redirect(socket, to: Format.link(record))}
      _ -> {:noreply, socket}
    end
  end

  def handle_event("set-focus", %{"key" => "ArrowUp"}, socket) do # UP
    current_focus =
      Enum.max([(socket.assigns.current_focus - 1), 0])
    {:noreply, assign(socket, current_focus: current_focus)}
  end

  def handle_event("set-focus", %{"key" => "ArrowDown"}, socket) do # DOWN
    current_focus =
      Enum.min([(socket.assigns.current_focus + 1), (length(socket.assigns.results) - 1)])
    {:noreply, assign(socket, current_focus: current_focus)}
  end

  # FALLBACK FOR NON RELATED KEY STROKES
  def handle_event("set-focus", _, socket), do: {:noreply, socket}
end
