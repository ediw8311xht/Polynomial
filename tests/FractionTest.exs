#!/bin/elixir
[
    "Fraction.exs",
]
|> Enum.each(&Code.require_file/1)
ExUnit.start()
defmodule FractionTest do
    use ExUnit.Case

    test "Fraction String Input" do
        a = Fraction.new("3/5") |> Fraction.to_float()
        assert a == 0.6
    end

    test "Fraction Simplify" do
        a = Fraction.new("9/18") |> Fraction.simplify()
        assert a.num == 1 and a.den == 2
    end

    test "Fraction Add" do
        a = Fraction.new("9/18")
        b = Fraction.new("3/4")
        c = Fraction.add(a, b) |> Fraction.to_float()
        assert c == 1.25
    end

    test "Zero Result" do
        a = Fraction.new("15/5")
        b = Fraction.new("-15/5")
        c = Fraction.add(a, b) |> Fraction.to_float()
        assert c == 0
    end
end
