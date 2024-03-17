#!/bin/elixir

Code.require_file("PolyTerm.exs")

defmodule Polynomial do
    defstruct figures: []

    def new(),     do: %Polynomial{figures: []}
    def new(p) when is_list(p), do: %Polynomial{figures: p}
    def new(p) when is_binary(p) do
        %Polynomial{figures:
            Regex.scan(~r/([-0-9]*[a-z](?:[\^][0-9]+)?|\b[-0-9]+\b)/, p, capture: :first)
            |> List.flatten()
            |> Enum.map( fn x ->
                PolyTerm.new(x)
        end)}
    end

    def prepend(%Polynomial{figures: figs}, polyterm = %PolyTerm{}) do
        Polynomial.new([polyterm | figs])
    end

    def add(polynomial = %Polynomial{figures: figs}, polyterm = %PolyTerm{}) do
        case Enum.find_index(figs, &(PolyTerm.can_add(&1, polyterm))) do
            x when x in [false, nil] -> prepend(polynomial, polyterm)
            index ->
                new_el = PolyTerm.add(Enum.at(figs, index), polyterm)
                List.replace_at(figs, index, new_el)
                |> Polynomial.new()
        end
    end

    def sort(%Polynomial{figures: figs}) do
        Enum.sort(figs, fn x, y ->
            PolyTerm.degree(x) >= PolyTerm.degree(y)
        end)
        |> Polynomial.new()
    end

    def simplify(%Polynomial{figures: figs}) do
        Enum.reduce(figs, Polynomial.new(), fn x, acc ->
            Polynomial.add(acc, x)
        end)
    end

end

defimpl String.Chars, for: Polynomial do
    def to_string(polynomial) do
        polynomial.figures
        |> Enum.reduce("", fn x, acc ->
            acc <> String.Chars.to_string(x) <> " "
        end)
    end
end

defmodule Main do
    def main() do
        polynomail_string = "14 5x^2 -9x^3 10x"
        a = Polynomial.new(polynomail_string)
        b = PolyTerm.new("20x^3")
        Polynomial.add(a, b)
        |> Polynomial.sort()
        |> IO.puts()
    end
end

Main.main()

