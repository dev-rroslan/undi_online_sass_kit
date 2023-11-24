defmodule UndiOnlineWeb.Schema do
  @moduledoc """
  Entrypoint for the GraphQL Schemas. To extend the schema, create a schema file
  and import it here.
  """
  use Absinthe.Schema

  alias UndiOnlineWeb.Schema

  import_types Absinthe.Type.Custom
  import_types Schema.UserTypes

  query do
    import_fields(:get_user)
  end

  mutation do
    import_fields(:login_mutation)
  end
end
