defprotocol UndiOnlineWeb.CommandPalette.Format do
  def header(value) # Returns a string
  def label(value) # Returns a string or a list of strings
  def link(value) # Returns a strong
end

defimpl UndiOnlineWeb.CommandPalette.Format, for: Map do
  def header(_), do: "Pages"
  def label(%{label: label}), do: label
  def link(%{path: path}), do: path
end
