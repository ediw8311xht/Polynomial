#!/bin/elixir

defmodule Helper do
    def sqrtceil(n)
    when is_integer(n) or is_float(n) do
        n |> :math.sqrt |> ceil
    end

    def is_factor(l, n)
    when is_list(l) and is_integer(n) do
        Enum.all?(l, &( rem(&1, n) == 0 ) )
    end

    def gcf(l)
    when is_list(l) do
        Enum.min(l)
        |> sqrtceil()
        |> Range.new(2)
        |> Enum.find(1, &(is_factor(l, &1)))
    end

    def simplify_by_gcf(l)
    when is_list(l) do
        f = gcf(l)
        Enum.map(l, &(round(&1 / f)))
    end

    def parsebit(""), do: 1
    def parsebit(x) do
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

