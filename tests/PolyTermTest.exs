#!/bin/elixir
[
    "PolyTerm.exs",
]
|> Enum.each(&Code.require_file/1)
ExUnit.start()
defmodule PolyTermTest do
    use ExUnit.Case

    test "Test PolyTerm.new" do
        assert PolyTerm.new("3/5x^2") == %PolyTerm{coe: %Fraction{num: 3, den: 5}, var: "x", exp: 2}
        assert PolyTerm.new("3x")     == %PolyTerm{coe: %Fraction{num: 3, den: 1}, var: "x", exp: 1}
        assert PolyTerm.new("9/8")    == %PolyTerm{coe: %Fraction{num: 9, den: 8}, var: "",  exp: 1}
    end
end
