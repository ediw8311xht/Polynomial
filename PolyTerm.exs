#!/bin/elixir

[
    "Fraction.exs"      ,
    "Helper.exs"        ,
]
|> Enum.each(&Code.require_file/1)
defmodule PolyTerm do
    @group_regex ~r{(?<coe>^[-0-9]+)?(?<frac>[/][-0-9]+)?(?<var>[a-z])?[\^]?(?<exp>[-0-9]+$)?}
    @def_exp 1
    defstruct coe: 1, var: "", exp: 1

    def new(c = %Fraction{}, v, e),     do: %PolyTerm{coe: c, var: v, exp: e}
    def new(c, v, e) when is_number(c), do: PolyTerm.new(Fraction.new(c), v, e)
    def new(c, v),                      do: PolyTerm.new(c, v, @def_exp)
    def new(coe: c, var: v, exp: e),    do: PolyTerm.new(c, v, e)
    def new(s) when is_binary(s) do
        %{"coe" => c, "frac" => f, "var" => v, "exp" => e} = Regex.named_captures(@group_regex, s)
        #a = [Helper.parsebit(c), v, (if v == "", do: 1, else: Helper.parsebit(e))]
        #Kernel.apply(PolyTerm, :new, a)
        PolyTerm.new(Fraction.new(c <> f), v, Helper.toint(e))
    end

    def degree(%PolyTerm{exp: e}), do: e

    def value(polyterm, var), do: Fraction.to_float(polyterm.coe) * (var ** polyterm.exp)

    def add(%PolyTerm{var: v1, exp: e1}, %PolyTerm{var: v2, exp: e2}) when v1 != v2 or e1 != e2, do: :nil

    def add(%PolyTerm{coe: c1, var: v1, exp: e1}, %PolyTerm{coe: c2}) do
        PolyTerm.new(Fraction.add(c1 + c2), v1, e1)
    end

    def compare(%PolyTerm{exp: e1, coe: c1}, %PolyTerm{exp: e2, coe: c2}) do
        e1 > e2 or (e1 == e2 and c1 > c2)
    end

    def divide(%PolyTerm{var: v1}, %PolyTerm{var: v2})
        when v1 != v2, do: :error
    def divide(%PolyTerm{coe: c1, var: v1, exp: e1}, %PolyTerm{coe: c2, var: _v2, exp: e2})
        when e1 < e2 or (e1 == e2 and c1 < c2), do: PolyTerm.new(c2, v1, e2)
    def divide(%PolyTerm{coe: c1, var: v1, exp: e1}, %PolyTerm{coe: c2, var: _v2, exp: e2}) do
        PolyTerm.new(c1 / c2, v1, e1 - e2)
    end

end

defimpl String.Chars, for: PolyTerm do
    def to_string(poly) do
        c = if poly.coe == 1, do: "", else: String.Chars.to_string(poly.coe)
        v = if poly.exp == 0, do: "", else: poly.var
        e = if poly.exp == 1 or poly.exp == 0, do: "", else: "^" <> String.Chars.to_string(poly.exp)
        c <> v <> e
    end
end

