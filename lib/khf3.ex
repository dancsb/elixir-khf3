defmodule Khf3 do

  @moduledoc """
  Kemping helyessége
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

  @type cnt_tree  :: integer                         # a fák száma a kempingben
  @type cnt_tent  :: integer                         # az elemek száma a sátorpozíciók irányának listájában
  @type err_rows  :: %{err_rows:  [integer]}         # a sátrak száma rossz a felsorolt sorokban
  @type err_cols  :: %{err_cols:  [integer]}         # a sátrak száma rossz a felsorolt oszlopokban
  @type err_touch :: %{err_touch: [field]}           # a felsorolt koordinátájú sátrak másikat érintenek
  @type errs_desc :: {err_rows, err_cols, err_touch} # hibaleíró hármas

  @spec check_sol(pd::puzzle_desc, ds::tent_dirs) :: ed::errs_desc
  # Az {rs, cs, ts} = pd feladványleíró és a ds sátorirány-lista
  # alapján elvégzett ellenőrzés eredménye a cd hibaleíró, ahol
  #   rs a sátrak soronként elvárt számának a listája,
  #   cs a sátrak oszloponként elvárt számának a listája,
  #   ts a fákat tartalmazó parcellák koordinátájának a listája
  # Az {e_rows, e_cols, e_touch} = ed hármas elemei olyan
  # kulcs-érték párok, melyekben a kulcs a hiba jellegére utal, az
  # érték pedig a hibahelyeket felsoroló lista (üres, ha nincs hiba)
  def check_sol(pd, ds) do
    tents = elem(pd, 2) |> Enum.with_index |> Enum.map(fn({{row, col}, index}) ->
      case Enum.at(ds, index) do
        :n -> {row - 1, col}
        :e -> {row, col + 1}
        :s -> {row + 1, col}
        :w -> {row, col - 1}
      end
    end)

    tents_in_rows = 1..length(elem(pd, 0)) |> Enum.map(fn index -> Enum.count(tents, fn {row, _} -> index == row end ) end)
    tents_in_cols = 1..length(elem(pd, 1)) |> Enum.map(fn index -> Enum.count(tents, fn {_, col} -> index == col end ) end)

    err_rows = tents_in_rows |> Enum.with_index |> Enum.filter(fn {cnt, index} -> cnt != Enum.at(elem(pd, 0), index) and Enum.at(elem(pd, 0), index) >= 0 end) |> Enum.map(fn {_cnt, index} -> index + 1 end)
    err_cols = tents_in_cols |> Enum.with_index |> Enum.filter(fn {cnt, index} -> cnt != Enum.at(elem(pd, 1), index) and Enum.at(elem(pd, 1), index) >= 0 end) |> Enum.map(fn {_cnt, index} -> index + 1 end)

    err_touch = tents |> Enum.filter(fn {row, col} -> Enum.member?(tents, {row - 1, col}) or
                                                      Enum.member?(tents, {row, col + 1}) or
                                                      Enum.member?(tents, {row + 1, col}) or
                                                      Enum.member?(tents, {row, col - 1}) or
                                                      Enum.member?(tents, {row - 1, col + 1}) or
                                                      Enum.member?(tents, {row - 1, col - 1}) or
                                                      Enum.member?(tents, {row + 1, col + 1}) or
                                                      Enum.member?(tents, {row + 1, col - 1}) end) |> Enum.uniq()

    {%{err_rows: err_rows}, %{err_cols: err_cols}, %{err_touch: err_touch}}
  end

end
