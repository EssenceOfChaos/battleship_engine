defmodule BattleshipEngine.Ship do
   @moduledoc """
   The Ship model.
   """
   alias __MODULE__
   alias BattleshipEngine.Coordinate

   @enforce_keys [:coordinates, :hit_coordinates]
   defstruct [:coordinates, :hit_coordinates]

   def new(type, %Coordinate{} = upper_left) do
    with  [_|_] = offsets <- offsets(type),
          %MapSet{} = coordinates <- add_coordinates(offsets, upper_left)
    do
      {:ok, %Ship{coordinates: coordinates, hit_coordinates: MapSet.new()}}
    else
      error -> error
    end
 end

 def types(), do: [:battleship, :destroyer, :submarine, :cruiser, :minesweeper]

 def guess(ship, coordinate) do
    case MapSet.member?(ship.coordinates, coordinate) do
      true ->
        hit_coordinates = MapSet.put(ship.hit_coordinates, coordinate)
        {:hit, %{ship | hit_coordinates: hit_coordinates}}
      false -> :miss
    end
  end

  def sunk?(ship), do:
    MapSet.equal?(ship.coordinates, ship.hit_coordinates)

  def overlaps?(existing_ship, new_ship), do:
    not MapSet.disjoint?(existing_ship.coordinates, new_ship.coordinates)

 defp add_coordinates(offsets, upper_left) do
    Enum.reduce_while(offsets, MapSet.new(), fn offset, acc ->
      add_coordinate(acc, upper_left, offset)
    end)
  end

  defp add_coordinate(coordinates, %Coordinate{row: row, col: col},
       {row_offset, col_offset}) do
    case Coordinate.new(row + row_offset, col + col_offset) do
      {:ok, coordinate}             ->
        {:cont, MapSet.put(coordinates, coordinate)}
      {:error, :invalid_coordinate} ->
        {:halt, {:error, :invalid_coordinate}}
    end
  end

 defp offsets(:battleship),  do: [{0, 0}, {0, 1}, {0, 2}, {0, 3}, {0, 4}]
 defp offsets(:destroyer),   do: [{0, 0}, {0, 1}, {0, 2}, {0, 3}]
 defp offsets(:submarine),   do: [{0, 0}, {0, 1}, {0, 2}]
 defp offsets(:cruiser),     do: [{0, 0}, {0, 1}]
 defp offsets(:minesweeper), do: [{0, 0}]

end
