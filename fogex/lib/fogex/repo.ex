defmodule FogEx.Repo do
  use Ecto.Repo,
    otp_app: :fogex,
    adapter: Ecto.Adapters.Postgres
end
