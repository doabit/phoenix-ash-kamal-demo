defmodule AshDemo.Account.User do
  # Using Ash.Resource turns this module into an Ash resource.
  use Ash.Resource,
    # Tells Ash you want this resource to store its data in Postgres.
    data_layer: AshPostgres.DataLayer

  # The Postgres keyword is specific to the AshPostgres module.
  postgres do
    # Tells Postgres what to call the table
    table "users"
    # Tells Ash how to interface with the Postgres table
    repo AshDemo.Repo
  end

  # Defines convenience methods for
  # interacting with the resource programmatically.
  code_interface do
    define_for AshDemo.Account
    define :create, action: :create
    define :read_all, action: :read
    define :update, action: :update
    define :destroy, action: :destroy
    define :get_by_id, args: [:id], action: :by_id
  end

  actions do
    # Exposes default built in actions to manage the resource
    defaults [:create, :read, :update, :destroy]

    # Defines custom read action which fetches post by id.
    read :by_id do
      # This action has one argument :id of type :uuid
      argument :id, :uuid, allow_nil?: false
      # Tells us we expect this action to return a single result
      get? true
      # Filters the `:id` given in the argument
      # against the `id` of each element in the resource
      filter expr(id == ^arg(:id))
    end
  end

  # Attributes are simple pieces of data that exist in your resource
  attributes do
    # Add an autogenerated UUID primary key called `:id`.
    uuid_primary_key :id
    # Add a string type attribute called `:title`
    attribute :name, :string do
      # We don't want the title to ever be `nil`
      allow_nil? false
    end

    attribute :created_at, :utc_datetime_usec do
      # writeable? false
      private? true
      default &DateTime.utc_now/0
      match_other_defaults? true
      allow_nil? false
    end

    # Add a string type attribute called `:content`
    # If allow_nil? is not specified, then content can be nil
    # attribute :password_digest, :string
    # atrribute :password, :string do
    #   virtual true
    # end
    # atrribute :password_confirmation, :string, virtual: true
  end
end
