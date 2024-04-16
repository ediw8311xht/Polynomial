#!/bin/elixir

[
    "Helper.exs",
]
|> Enum.each(&Code.require_file/1)
defmodule Fraction do
    defstruct num: 0, den: 1

    def new(num, den), do: %Fraction{num: num, den: den}
    def new([a, b]),   do: Fraction.new(a, b)
    def new(n) when is_integer(n),   do: Fraction.new(n, 1)
    def new(s) when is_binary(s) do
        String.split(s, "/")
        |> Stream.map(&String.trim/1)
        |> Enum.map(&String.to_integer/1)
        |> case do
            [n, d]  -> Fraction.new(n, d)
            [n]     -> Fraction.new(n)
            _       -> :error
        end
    end

    def simplify(%Fraction{num: n, den: d}) do
        Helper.simplify_by_gcf([n, d])
        |> Fraction.new()
    end

    def to_float(%Fraction{num: n, den: d}), do: n / d

    def compare(f1 = %Fraction{}, f2 = %Fraction{}) do
        case for n <- [f1, f2], do: Fraction.to_float(n) do
            {x, y} when x > y -> :gt
            {x, y} when x < y -> :lt
            _                 -> :eq
        end
    end

    def add(%Fraction{num: n1, den: d1}, %Fraction{num: n2, den: d2}) do
        Fraction.new((n1 * d2) + (n2 * d1), d1 * d2)
        |> Fraction.simplify()
    end
end

defimpl String.Chars, for: Fraction do
    def to_string(%Fraction{num: n, den: 1}), do: "#{n}"
    def to_string(%Fraction{num: n, den: d}), do: "#{n}/#{d}"
    #def to_integer
end
