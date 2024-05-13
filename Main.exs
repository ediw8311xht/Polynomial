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
        num = Polynomial.new("2x^3 + -3x^2 + 4x + 5")
        den = Polynomial.new("x + 2")
        #den
        Polynomial.divide(num, den)
        #Polynomial.subtract(num, den)
        #IO.puts(Polynomial.simplify(num))
        #Polynomial.simplify(den)
        #Polynomial.multiply(a, den)
        #num = PolyTerm.new("8")
        #Polynomial.new("5")
        #|> IO.puts()
        #[Polynomial.leading_term(num), Polynomial.leading_term(den)]
        #Polynomial.leading_term(test1)
        #l1 = Polynomial.leading_term(num)
        #l2 = Polynomial.leading_term(den)
        #PolyTerm.divide(l1, l2)

        #|> Polynomial.simplify()
        #|> IO.puts()
        #a = Fraction.new(-15, 5)
        #b = Fraction.new(15, 5)
        #Fraction.add(b, a)
        #Helper.gcf([15, 5])
        #Enum.min([15, 5])..1//-1
        #Enum.min([15, 5])
        #Helper.simplify_by_gcf([15, 5])
        #|> Fraction.simplify()
        #Helper.is_factor([15, 5], 3)
        #IO.puts("HI")
    end
end

System.argv()
|> Main.main()
|> IO.inspect()
