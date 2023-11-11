defmodule AshDemo.Blog do
  use Ash.Api

  resources do
    registry AshDemo.Blog.Registry
  end
end
