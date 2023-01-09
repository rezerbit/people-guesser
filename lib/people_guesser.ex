defmodule PeopleGuesser do
  use Application
  use Hound.Helpers

  def start(_types, _args) do
    IO.puts("Run")

    Hound.start_session()

    navigate_to_start_page()
    auth()
    start_game()
    Process.sleep(5_000)

    Hound.end_session()
  end

  defp navigate_to_start_page do
    navigate_to("https://people.funbox.ru/meet/")
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

  defp start_game() do
    find_element(:class, "how-to-play__button")
    |> click()

    IO.puts("Start new game")
    do_game(%{guesses_cont: 0, success_cont: 0})
  end

  defp do_game(%{guesses_cont: guesses_cont, success_cont: success_cont} = st) do
    Process.sleep(4000 + :rand.uniform(200))
    IO.puts(user_hash())

    options =
      find_element(:class, "game__options")
      |> find_all_within_element(:class, "game__option")

    names =
      Enum.map(options, fn element ->
        element
        |> find_within_element(:class, "game__name")
        |> visible_text()
        |> process_name()
      end)

    IO.inspect(names)

    save_name_and_options()

    find_most_likely_name(names)
    |> click_name()

    guesses_cont = guesses_cont + 1

    case search_element(:class, "game__additional-time") do
      {:ok, element} ->
        IO.puts inner_text(element)
        if inner_text(element) == "+1", do: success_cont = success_cont + 1

        IO.puts("guesses: #{guesses_cont}, success: #{success_cont}")
        do_game(%{st | guesses_cont: guesses_cont, success_cont: success_cont})

      other ->
        IO.puts("GAME OVER. Guesses: #{guesses_cont}. Success: #{success_cont}")
        IO.puts("______________________________________________")

        find_element(:class, "personal-results__new-game")
        |> click()

        do_game(%{st | guesses_cont: 0, success_cont: 0})
    end
  end

  defp process_name(name) do
    name
    |> String.split()
    |> Enum.take(2)
    |> Enum.map(fn word -> String.capitalize(word) end)
    |> Enum.join(" ")
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
