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
    def new(p) when is_list(p),  do: %Polynomial{figures: Enum.filter(p, &PolyTerm.not_zero/1)}
    def new(p) when is_binary(p) do
        Regex.scan(@scanregex, p, capture: :first)
        |> List.flatten()
        |> Enum.filter(&(&1 != ""))
        |> Enum.map( &(PolyTerm.new(&1)))
        |> Polynomial.new()
    end

    def leading_term( %Polynomial{figures: []}   ), do: :nil
    def leading_term( %Polynomial{figures: figs} ), do: Enum.max_by(figs, &(&1.exp))

    def combine(%Polynomial{figures: figs1}, %Polynomial{figures: figs2}) do
        Polynomial.new(figs1 ++ figs2) |> Polynomial.simplify()
    end

    def prepend(%Polynomial{figures: figs}, p = %PolyTerm{}), do: Polynomial.new([p | figs])

    def add(polynomial = %Polynomial{figures: figs}, polyterm = %PolyTerm{}) do
        case Helper.fchange(figs, &PolyTerm.add/2, polyterm) do
            :nil            ->   prepend(polynomial, polyterm)
            new_fig_list    ->   Polynomial.new(new_fig_list)
        end
    end

    def subtract(poly = %Polynomial{}, %Polynomial{figures: figs2}) do
        Enum.map(figs2, &(PolyTerm.multiply(&1, PolyTerm.new(-1, "", 0))))
        |> Polynomial.new()
        |> Polynomial.combine(poly)
    end

    def sort(%Polynomial{figures: figs}) do
        Enum.sort(figs, &(PolyTerm.degree(&1) >= PolyTerm.degree(&2)))
        |> Polynomial.new()
    end

    def simplify(%Polynomial{figures: figs}) do
        Enum.reduce(figs, Polynomial.new(), fn x, acc -> Polynomial.add(acc, x) end)
        |> Polynomial.sort()
    end

    def multiply(%Polynomial{figures: figs}, poly2 = %Polynomial{}) do
        Enum.reduce(figs, Polynomial.new(), fn term, acc ->
            Polynomial.combine(acc, Polynomial.multiply(term, poly2))
        end)
        |> Polynomial.new()
    end

    def multiply(term = %PolyTerm{}, %Polynomial{figures: figs}) do
        Enum.map(figs, &(PolyTerm.multiply(&1, term)))
        |> Polynomial.new()
    end

    #------------DIVISION---------#
    def divide(s1 = %Polynomial{}, s2 = %Polynomial{}) do
        {res, rem} = internal_divide(simplify(s1), simplify(s2))
        %{res: res, rem: rem}
    end
    defp internal_divide(s1 = %Polynomial{}, s2 = %Polynomial{}) do
        l1 = leading_term(s1); l2 = leading_term(s2)
        if l1 == :nil or l2 == :nil or l1.exp == 0 do
            {false, s1}
        else
            quotient = PolyTerm.divide(l1, l2)
            remainder = Polynomial.subtract(s1, Polynomial.multiply(quotient, s2))
            case internal_divide(remainder, s2) do
                {false, r} ->
                    {Polynomial.new([quotient]), r}
                {q, r} ->
                    {Polynomial.add(q, quotient), r}
            end
        end
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

