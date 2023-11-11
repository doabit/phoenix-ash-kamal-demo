defmodule AshDemo.Release do
  @moduledoc """
  Used for executing DB release tasks when run in production without Mix
  installed.
  """
  @app :ash_demo

  def migrate do
    load_app()

    for repo <- repos() do
      {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, all: true))
    end
  end

  def rollback(repo, version) do
    load_app()
    {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :down, to: version))
  end

  defp repos do
    apis()
    |> Enum.flat_map(fn api ->
      api
      |> Ash.Api.Info.resources()
      |> Enum.map(&AshPostgres.repo/1)
    end)
    |> Enum.uniq()
  end

  defp apis do
    Application.fetch_env!(:ash_demo, :ash_apis)
  end

  defp load_app do
    Application.load(@app)
  end
end
