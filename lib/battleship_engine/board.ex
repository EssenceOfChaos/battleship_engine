defmodule BattleshipEngine.Board do
    @moduledoc """
    The Game Board
    """
    alias BattleshipEngine.{Coordinate, Ship}

    def new(), do: %{}

    def position_ship(board, key, %Ship{} = ship) do
        case overlaps_existing_ship?(board, key, ship) do
          true  -> {:error, :overlapping_ship}
          false -> Map.put(board, key, ship)
        end
      end

      def guess(board, %Coordinate{} = coordinate) do
        board
        |> check_all_ships(coordinate)
        |> guess_response(board)
      end

      defp check_all_ships(board, coordinate) do
        Enum.find_value(board, :miss, fn {key, ship} ->
          case Ship.guess(ship, coordinate) do
           {:hit, ship} -> {key, ship}
           :miss          -> false
          end
        end)
      end

      defp guess_response({key, ship}, board) do
        board = %{board | key => ship}
        {:hit, sunk_check(board, key), win_check(board), board}
      end

      defp guess_response(:miss, board), do: {:miss, :none, :no_win, board}

      def all_ships_positioned?(board), do:
        Enum.all?(Ship.types, &(Map.has_key?(board, &1)))

      defp overlaps_existing_ship?(board, new_key, new_ship) do
        Enum.any?(board, fn {key, ship} ->
          key != new_key and Ship.overlaps?(ship, new_ship)
        end)
      end

      defp sunk_check(board, key) do
        case sunk?(board, key) do
          true  -> key
          false -> :none
        end
      end

      defp sunk?(board, key) do
        board
        |> Map.fetch!(key)
        |> Ship.sunk?()
      end

      defp win_check(board) do
        case all_sunk?(board) do
          true  -> :win
          false -> :no_win
        end
      end

      defp all_sunk?(board), do:
        Enum.all?(board, fn {_key, ship} -> Ship.sunk?(ship) end)

end
