#!/bin/elixir

[
    "Helper.exs",
]
|> Enum.each(&Code.require_file/1)
defmodule Fraction do
    @capture_regex ~r{^(?<num>[0-9]+)/(?<den>[0-9]+)$}
    defstruct num: 0, den: 1

    def new(num, den), do: %Fraction{num: num, den: den}
    def new(s) when is_integer(s), do: Fraction.new(s, 1)
    def new(s) when is_binary(s) do
        case Regex.named_captures(@capture_regex, s) do
            %{"num" => num, "den" => den} ->
                Fraction.new(String.to_integer(num), String.to_integer(den))
            _ -> :error
        end
    end

    def simplify(%Fraction{num: n, den: d}) do
        [sn, sd] = Helper.simplify_by_gcf([n, d])
        Fraction.new(sn, sd)
    end
end

defimpl String.Chars, for: Fraction do
    def to_string(%Fraction{num: n, den: d}), do: "#{n}/#{d}"
end

