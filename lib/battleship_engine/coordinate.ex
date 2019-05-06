defmodule BattleshipEngine.Coordinate do
    @moduledoc """
    The Coordinate model, defined as `%%BattleshipEngine.Coordinate{row: x, col: y}`
    """
    alias __MODULE__

    @enforce_keys [:row, :col]
    defstruct [:row, :col]

    # @row_range 1..10
    # @col_range ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j"]

    @board_range 1..10

    def new(row, col)  when row in(@board_range) and col in(@board_range), do:
      {:ok, %Coordinate{row: row, col: col}}

    def new(_row, _col), do: {:error, :invalid_coordinate}
  end
