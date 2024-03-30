#!/bin/elixir

Code.require_file("Polynomial.exs")

defmodule Main do
    def main([p1 | [p2]]) do
        p1 = Polynomial.new_simplify(p1)
        p2 = Polynomial.new_simplify(p2)
        #|> Polynomial.sort()
        #IO.inspect(p1)
        l1 = Polynomial.leading_term(p1)
        l2 = Polynomial.leading_term(p2)
        IO.puts("#{l1}, #{l2}")
        Polynomial.division(p1, p2)
        |> IO.inspect()
        PolyTerm.divide(l1, l2)
        |> IO.inspect()
    end
    def main(_) do
        :error
    end
end

System.argv()
|> Main.main()
|> IO.puts()
