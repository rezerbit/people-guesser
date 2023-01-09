defmodule PeopleGuesser do
  use Application
  use Hound.Helpers

  def start(_types, _args) do
    IO.puts("Start")
    Application.ensure_all_started(:hound)

    Hound.start_session()

    navigate_to("https://people.funbox.ru/meet/")

    auth()

    find_element(:class, "how-to-play__button")
    |> click()

    Process.sleep(5_000)

    Hound.end_session()
  end

  defp auth do
    auth_config = Application.fetch_env!(:people_guesser, :auth)

    find_element(:id, "username")
    |> fill_field(Keyword.fetch!(auth_config, :login))

    find_element(:id, "password")
    |> fill_field(Keyword.fetch!(auth_config, :password))

    find_element(:class, "button")
    |> click()
  end
end
