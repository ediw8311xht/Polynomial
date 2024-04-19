#!/bin/elixir

[
    "PolyTerm.exs"      ,
    "Fraction.exs"      ,
    "Helper.exs"        ,
]
|> Enum.each(&Code.require_file/1)
defmodule Polynomial do
    @scanregex ~r{([-0-9/]*[a-z]?(?:[\^][0-9]+)?|\b[-0-9]+\b)}
    defstruct figures: []

    def new(),                   do: %Polynomial{figures: []}
    def new(p) when is_list(p),  do: %Polynomial{figures: p}
    def new(p) when is_binary(p) do
        Regex.scan(@scanregex, p, capture: :first)
        |> List.flatten()
        |> Enum.filter(&(&1 != ""))
        |> Enum.map( &(PolyTerm.new(&1)))
        |> Polynomial.new()
    end

    def leading_term(%Polynomial{figures: figs}), do: Enum.max_by(figs, &(&1.exp))

    def prepend(%Polynomial{figures: figs}, p = %PolyTerm{}), do: Polynomial.new([p | figs])

    def add(polynomial = %Polynomial{figures: figs}, polyterm = %PolyTerm{}) do
        case Helper.fchange(figs, &PolyTerm.add/2, polyterm) do
            :nil            ->   prepend(polynomial, polyterm)
            new_fig_list    ->   Polynomial.new(new_fig_list)
        end
    end

    def sort(%Polynomial{figures: figs}) do
        Enum.sort(figs, &(PolyTerm.degree(&1) >= PolyTerm.degree(&2)))
        |> Polynomial.new()
    end

    def simplify(%Polynomial{figures: figs}), do: Enum.reduce(figs, Polynomial.new(), fn x, acc -> Polynomial.add(acc, x) end)

    #------------DIVISION---------#
    def division(p1 = %Polynomial{}, p2 = %Polynomial{}), do: internal_division(sort(p1), sort(p2))

    defp internal_division(s1 = %Polynomial{}, s2 = %Polynomial{}, result \\ %Polynomial{figures: []}) do
        l1 = leading_term(s1); l2 = leading_term(s2)
        if PolyTerm.compare(l1, l2) in [:gt, :eq] do
            divide_step(s1, s2)
            #|> internal_division()
        else
            result
        end
    end

    defp divide_step(s1 = %Polynomial{}, s2 = %Polynomial{}) do
        [s1, s2]
    end
    #-----------------------------#

end

defimpl String.Chars, for: Polynomial do
    def to_string(%Polynomial{figures: figs}) do
        Enum.reduce(figs, "", fn x, acc ->
            acc <> String.Chars.to_string(x) <> " "
        end)
        |> String.trim()
    end
end

