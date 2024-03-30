#!/bin/elixir

Code.require_file("PolyTerm.exs")

defmodule Polynomial do
    @scanregex ~r/([-0-9]*[a-z](?:[\^][0-9]+)?|\b[-0-9]+\b)/
    defstruct figures: []

    def new(),                   do: %Polynomial{figures: []}
    def new(p) when is_list(p),  do: %Polynomial{figures: p}
    def new(p) when is_binary(p) do
        %Polynomial{figures:
            Regex.scan(@scanregex, p, capture: :first)
            |> List.flatten()
            |> Enum.map( fn x ->
                PolyTerm.new(x)
        end)}
    end
    def new_simplify(p), do: new(p) |> simplify()

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
        Enum.sort(figs, &(PolyTerm.degree(&1) >= PolyTerm.degree(&2)))
        |> Polynomial.new()
    end

    def simplify(%Polynomial{figures: figs}) do
        Enum.reduce(figs, Polynomial.new(), fn x, acc -> Polynomial.add(acc, x) end)
    end

    def leading_term(%Polynomial{figures: figs}) do
        Enum.max_by(figs, &(&1.exp))
    end

    #------------DIVISION---------#
    def division(p1 = %Polynomial{}, p2 = %Polynomial{}) do
        internal_division(sort(p1), sort(p2))
    end

    defp internal_division(s1 = %Polynomial{}, s2 = %Polynomial{}, result \\ %Polynomial{figures: []}) do
        l1 = leading_term(s1)
        l2 = leading_term(s2)
        if PolyTerm.compare(l1, l2) do
            divide_step(s1, s2)
            #|> internal_division()
        else
            result
        end
    end

    defp divide_step(s1 = %Polynomial{}, s2 = %Polynomial{}) do
    end
    #-----------------------------#

end

defimpl String.Chars, for: Polynomial do
    def to_string(%Polynomial{figures: figs}) do
        Enum.reduce(figs, "", fn x, acc ->
            acc <> String.Chars.to_string(x) <> " "
        end)
    end
end

