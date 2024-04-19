#!/bin/elixir
[
    "Polynomial.exs",
]
|> Enum.each(&Code.require_file/1)
ExUnit.start()
defmodule PolynomialTest do
    use ExUnit.Case

    test "Polynomial String Input" do
        a = Polynomial.new("-8/5 3x^5 2x 4x^2 9x^5 -9 10x")
        b = a |> Polynomial.sort() |> String.Chars.to_string()
        assert b == "3x^5 9x^5 4x^2 8/-5 2x -9 10x"
        c = a |> Polynomial.simplify() |> Polynomial.sort() |> String.Chars.to_string()
        assert c == "12x^5 4x^2 12x -53/5"
    end
end
