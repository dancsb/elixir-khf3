_p0 = {pd0, ts0} =
  { {[-1, 0, 0, -3, 0], [0, 0, -2, 0, 0], []}, [] }
_p1 = {pd1, ts1} =
  { {[1, 0, 0, 3, 0], [0, 0, 2, 0, 0], []}, [] }
_p2 = {pd2, ts2} =
  { {[1, 1, 0, 3, 0], [1, 0, 2, 0, 2], [{1, 2}, {3, 3}, {3, 5}, {5, 1}, {5, 5}]}, [:e,:s,:n,:n,:n] }
_p3 = {pd3, ts3} =
  { {[1, 1, 0, 3, 0], [1, 0, 2, 0, 2], [{1, 2}, {3, 3}, {3, 5}, {5, 1}, {5, 5}]}, [:e,:e,:n,:n,:n] }
_p4 = {pd4, ts4} =
  { {[1, 0, 2, 2, 0], [1, 0, 0, 2, 1], [{1, 2}, {3, 3}, {3, 5}, {5, 1}, {5, 5}]}, [:e,:e,:n,:n,:n] }
_p5 = {pd5, ts5} =
  { {[1, 1, -1, 3, 0], [1, 0, -2, 0, 2], [{1, 2}, {3, 3}, {3, 5}, {5, 1}, {5, 5}]}, [:e,:s,:n,:n,:w] }
_p6 = {pd6, ts6} =
{ {[0, 3, 2, 0, 2, 1, 1], [1, 2, 0, 3, 0, 1, 1, 1], [{1, 4}, {1, 8}, {2, 2}, {3, 3}, {3, 6},
  {5, 2}, {5, 5}, {5, 7}, {7, 3}]}, [:s, :s, :s, :e, :n, :w, :w, :s, :w] }

IO.puts "--- p0"
pd0 |> IO.inspect
ts0 |> IO.inspect
Khf2.to_external pd0, ts0, "x.txt"; (File.read! "x.txt") |> IO.write
(Khf3.check_sol pd0, ts0) |> IO.inspect

IO.puts "--- p1"
pd1 |> IO.inspect
ts1 |> IO.inspect
Khf2.to_external pd1, ts1, "x.txt"; (File.read! "x.txt") |> IO.write
(Khf3.check_sol pd1, ts1) |> IO.inspect


IO.puts "--- p2"
pd2 |> IO.inspect
ts2 |> IO.inspect
Khf2.to_external pd2, ts2, "x.txt"; (File.read! "x.txt") |> IO.write
(Khf3.check_sol pd2, ts2) |> IO.inspect

IO.puts "--- p3"
pd3 |> IO.inspect
ts3 |> IO.inspect
Khf2.to_external pd3, ts3, "x.txt"; (File.read! "x.txt") |> IO.write
(Khf3.check_sol pd3, ts3) |> IO.inspect

IO.puts "--- p4"
pd4 |> IO.inspect
ts4 |> IO.inspect
Khf2.to_external pd4, ts4, "x.txt"; (File.read! "x.txt") |> IO.write
(Khf3.check_sol pd4, ts4) |> IO.inspect

IO.puts "--- p5"
pd5 |> IO.inspect
ts5 |> IO.inspect
Khf2.to_external pd5, ts5, "x.txt"; (File.read! "x.txt") |> IO.write
(Khf3.check_sol pd5, ts5) |> IO.inspect

IO.puts "--- p6"
pd5 |> IO.inspect
ts5 |> IO.inspect
Khf2.to_external pd6, ts6, "x.txt"; (File.read! "x.txt") |> IO.write
(Khf3.check_sol pd6, ts6) |> IO.inspect
IO.puts "---"
