defmodule AshDemo.Account do
  use Ash.Api

  resources do
    registry AshDemo.Account.Registry
  end
end
