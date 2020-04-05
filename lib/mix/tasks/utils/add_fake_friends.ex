defmodule Mix.Tasks.Utils.AddFakeFriends do
  use Mix.Task
  alias NimbleCSV.RFC4180, as: CSVParser
  alias FriendsApp.CLI.Friend

  @shortdoc "Add Fake Friends on App"
  def run(_) do
    Faker.start()

    create_friends(50)
    |> CSVParser.dump_to_iodata
    |> save_csv_file()

    IO.puts("Amigos cadastrados com sucesso!")
  end
  
  defp create_friends(count), do: create_friends_recursively([], count)
  
  ## Feito na aula, recursão

  # defp create_friends_recursively(list, count) when count <= 1 do
  #   list ++ [random_list_friend()]
  # end

  # defp create_friends_recursively(list, count) do
  #   list ++ [random_list_friend()] ++ create_friends(list, count - 1)
  # end

  ## Recursão com cond e tail-call optimization

  # defp create_friends_recursively(list, count) do
  #   cond do
  #     count <= 1 -> [random_list_friend() | list]
  #     true -> create_friends_recursively([random_list_friend() | list], count - 1)
  #   end
  # end

  ## Recursão com cond e tail-call optimization

  defp create_friends_recursively(list, count) when count <= 1, do: [random_list_friend() | list]

  defp create_friends_recursively(list, count), do: create_friends_recursively([random_list_friend() | list], count - 1)

  ## Usando Enum.reduce

  # defp create_friends(count) do
  #   1..count
  #   |> Enum.reduce([], fn (_, acc) ->
  #     [random_list_friend() | acc]
  #   end)
  # end
  
  defp random_list_friend() do
    %Friend{
      name: Faker.Name.PtBr.name(),
      email: Faker.Internet.email(),
      phone: Faker.Phone.EnUs.phone()
    }
    |> Map.from_struct
    |> Map.values
  end

  defp save_csv_file(data) do
    Application.fetch_env!(:friends_app, :csv_file_path)
    |> File.write!(data, [:append])
  end
end