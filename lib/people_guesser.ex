defmodule PeopleGuesser do
  use Application
  use Hound.Helpers

  def start(_types, _args) do
    IO.puts("Start")

    Hound.start_session()

    navigate_to("https://people.funbox.ru/meet/")

    auth()

    find_element(:class, "how-to-play__button")
    |> click()

    do_game()

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

  defp do_game(st \\ %{status: :new})

  defp do_game(%{status: :new} = st) do
    IO.puts(user_hash())

    Process.sleep(1000)

    options =
      find_element(:class, "game__options")
      |> find_all_within_element(:class, "game__option")

    names =
      Enum.map(options, fn element ->
        element
        |> find_within_element(:class, "game__name")
        |> visible_text()
        |> String.split() |> Enum.into([], fn word -> String.capitalize(word) end) |> Enum.join(" ")
      end)

    save_name_and_options()


    find_most_likely_name(names)
    |> click_name()

    Process.sleep(100_000)



    # if do
    #   find_element(:class, "personal-results__new-game")
    #   |> click()
    # else
    # end
  end

  defp do_game(%{status: :game_over} = st) do
    do_game(%{st | status: :new})
  end

  defp user_hash() do
    user_url()
    |> String.split("?")
    |> List.last()
  end

  defp user_url do
    find_element(:class, "game__avatar")
    |> attribute_value(:src)
  end

  defp save_name_and_options do
  end

  defp find_most_likely_name(names) do
    select_name(names)
  end

  defp select_name(names) do
    select_random_name(names)
  end

  defp select_random_name(names) do
    Enum.take_random(names, 1) |> hd()
  end

  defp click_name(name) do
    find_element(:xpath, "//div[contains(@class, 'game__option')]/p[contains(text(), '#{name}')]")
    |> click()
  end
end
