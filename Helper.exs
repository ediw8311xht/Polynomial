#!/bin/elixir

defmodule Helper do
    def sqrtceil(n)
    when is_integer(n) or is_float(n) do
        n |> :math.sqrt |> ceil
    end

    def is_factor(l, n), do: Enum.all?(l, &( rem(&1, n) == 0 ) )

    def gcf(l), do: Enum.find(Enum.min(l)..1, 1, &(is_factor(l, &1)))

    def simplify_by_gcf(l) do
        f = gcf(l)
        Enum.map(l, &(round(&1 / f)))
    end

    def toint(""), do: 1
    def toint(x) do
        case Integer.parse(x) do
            {a, ""}  -> a
            :error   -> x
        end
    end

    def  fchange(  l,  f,  args \\ []), do: pfchange(l, f, args, length(l) - 1)
    defp pfchange(_l, _f, _args,   -1), do: :nil
    defp pfchange( l,  f,  args,  i) do
        case apply(f, [Enum.at(l, i) | [args]]) do
            :nil      -> pfchange(l, f, args, i - 1)
            new_value -> List.replace_at(l, i, new_value)
        end
    end
end

