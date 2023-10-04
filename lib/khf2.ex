defmodule Khf2 do

  @moduledoc """
  Kemping térképe
  @author "Dancs Balázs <dancs.balazs01@gmail.com>"
  @date   "2023-10-01"
  ...
  """

  @type row   :: integer    # sor száma (1-től n-ig)
  @type col   :: integer    # oszlop száma (1-től m-ig)
  @type field :: {row, col} # egy parcella koordinátái

  @type tents_count_rows :: [integer] # a sátrak száma soronként
  @type tents_count_cols :: [integer] # a sátrak száma oszloponként

  @type trees       :: [field]   # a fákat tartalmazó parcellák koordinátái lexikálisan rendezve
  @type puzzle_desc :: {tents_count_rows, tents_count_cols, trees} # a feladványleíró hármas

  @type dir       :: :n | :e | :s | :w # a sátorpozíciók iránya: north, east, south, west
  @type tent_dirs :: [dir]             # a sátorpozíciók irányának listája a fákhoz képest

  @spec solve_problem(lines::[String.t], trees::trees, ds::tent_dirs, row::integer, col::integer, max_col::integer) :: [String.t]
  defp solve_problem(lines, trees, ds, row, col, max_col) do
    iterate_rows(lines, trees, ds, row, col, max_col)
  end

  @spec iterate_rows([String.t], trees::trees, ds::tent_dirs, row::integer, col::integer, max_col::integer) :: [String.t]
  defp iterate_rows([line | rest], trees, ds, row, col, max_col) do
    new_line = iterate_cols(line, trees, ds, row, col, max_col)
    [line <> new_line | iterate_rows(rest, trees, ds, row + 1, col, max_col)]
  end

  defp iterate_rows([], _trees, _ds, _row, _col, _max_col) do
    []
  end

  @spec iterate_cols(line::String.t, trees::trees, ds::tent_dirs, row::integer, col::integer, max_col::integer) :: String.t
  defp iterate_cols(line, trees, ds, row, col, max_col) do
    case col do
      x when x == max_col -> determine_symbol(row, col, trees, ds)
      _ -> determine_symbol(row, col, trees, ds) <> "  " <> iterate_cols(line, trees, ds, row, col + 1, max_col)
    end
  end

  @spec determine_symbol(row::integer, col::integer, trees::trees, ds::tent_dirs) :: String.t
  defp determine_symbol(row, col, trees, ds) do
    case Enum.member?(trees, {row, col}) do
      true -> "*"
      false -> if is_dir?(row + 1, col, trees, ds, :n) do
                 "N"
               else
                 if is_dir?(row, col - 1, trees, ds, :e) do
                   "E"
                 else
                   if is_dir?(row - 1, col, trees, ds, :s) do
                     "S"
                   else
                     if is_dir?(row, col + 1, trees, ds, :w) do
                       "W"
                     else
                       "-"
                     end
                   end
                 end
               end
    end
  end

  @spec is_dir?(row::integer, col::integer, trees::trees, ds::tent_dirs, dir::dir) :: boolean
  defp is_dir?(row, col, trees, ds, dir) do
    case Enum.find_index(trees, &(&1 == {row, col})) do
      nil -> false
      x -> if Enum.at(ds, x) == dir do
             true
           else
             false
           end
    end
  end

  @spec to_external(pd::puzzle_desc, ds::tent_dirs, file::String.t) :: :ok
  # A pd = {rs, cs, ts} feladványleíró és a ds sátorirány-lista alapján
  # a feladvány szöveges ábrázolását írja ki a file fájlba, ahol
  #   rs a sátrak soronkénti számának a listája,
  #   cs a sátrak oszloponkénti számának a listája,
  #   ts a fákat tartalmazó parcellák koordinátájának listája
  def to_external(pd, ds, file) do
    output = File.open!(file, [:write])
    IO.binwrite(output, "   ")
    Enum.each(elem(pd, 1), fn element ->
      IO.binwrite(output, "#{element}  ")
    end)
    IO.binwrite(output, "\n")

    solution = Enum.map(elem(pd, 0), fn x ->
      "#{x}  "
    end)

    solution = solve_problem(solution, elem(pd, 2), ds, 1, 1, length(elem(pd, 1)))
    Enum.each(solution, fn x ->
      IO.binwrite(output, "#{x}\n")
    end)

    File.close(output)
    :ok
  end

end
