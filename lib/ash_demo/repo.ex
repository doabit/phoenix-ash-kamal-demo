defmodule AshDemo.Repo do
  use AshPostgres.Repo,
    otp_app: :ash_demo
    # adapter: Ecto.Adapters.Postgres

  def installed_extensions do
     ["uuid-ossp", "citext"]
   end
end
