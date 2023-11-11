defmodule AshDemo.Account.Registry do
  use Ash.Registry,
    extensions: [
      # This extension adds helpful compile time validations
      Ash.Registry.ResourceValidations
    ]

  entries do
    entry AshDemo.Account.User
  end
end
