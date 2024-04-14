#!/bin/elixir

[
    "Polynomial.exs"        ,
    "PolyTerm.exs"          ,
    "Fraction.exs"          ,
    "Helper.exs"            ,
]
|> Enum.each(&Code.require_file/1)
defmodule Main do
    @moduledoc """
    """
    def main([p1 | [p2]]) do
        n1 = Polynomial.new(p1)
        n2 = Polynomial.new(p2)
        IO.inspect(n1)
        IO.inspect(n2)
        #l1 = Polynomial.leading_term(p1)
        #l2 = Polynomial.leading_term(p2)
        ##IO.puts("#{l1}, #{l2}")
        ##Polynomial.division(p1, p2)
        ##|> IO.pust()
        #PolyTerm.divide(l1, l2)
        #|> IO.puts()
    end
    def main(_) do
        Polynomial.new("8 3x^5 2x 4x^2 9x^5 9 10x")
        |> Polynomial.simplify()
        |> Polynomial.sort()
        Fraction.new(3, 9)
        |> Fraction.simplify()
        #Helper.is_factor([15, 5], 3)
    end
end

System.argv()
|> Main.main()
|> IO.puts()
