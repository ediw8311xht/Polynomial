#!/bin/elixir

[
    "Fraction.exs"      ,
    "Helper.exs"        ,
]
|> Enum.each(&Code.require_file/1)
defmodule PolyTerm do
    @group_regex ~r{(?<coe>^[-0-9]+)?(?<var>[a-z])?[\^]?(?<exp>[-0-9]+$)?}
    @def_coe  1; @def_exp  1; @def_var  ""
    defstruct coe: @def_coe, var: @def_var, exp: @def_exp

    def new(c, v, e \\ @def_var), do: %PolyTerm{coe: c, var: v, exp: e}

    def new(s) do
        %{"coe" => c, "var" => v, "exp" => e} = Regex.named_captures(@group_regex, s)
        a = [Helper.parsebit(c), v, (if v == "", do: 1, else: Helper.parsebit(e))]
        Kernel.apply(PolyTerm, :new, a)
    end

    def degree(%PolyTerm{exp: e}), do: e

    def value(polyterm, var), do: polyterm.coe * (var ** polyterm.exp)

    def add(%PolyTerm{var: v1, exp: e1}, %PolyTerm{var: v2, exp: e2})
        when v1 != v2 or e1 != e2, do: :nil

    def add(%PolyTerm{coe: c1, var: v1, exp: e1}, %PolyTerm{coe: c2}), do: PolyTerm.new(c1 + c2, v1, e1)


    def divide(%PolyTerm{var: v1}, %PolyTerm{var: v2})
        when v1 != v2, do: :error
    def divide(%PolyTerm{coe: c1, var: v1, exp: e1}, %PolyTerm{coe: c2, var: _v2, exp: e2})
        when e1 < e2 or (e1 == e2 and c1 < c2), do: PolyTerm.new(c2, v1, e2)
    def divide(%PolyTerm{coe: c1, var: v1, exp: e1}, %PolyTerm{coe: c2, var: _v2, exp: e2}) do
        PolyTerm.new(c1 / c2, v1, e1 - e2)
    end

    def compare(%PolyTerm{exp: e1, coe: c1}, %PolyTerm{exp: e2, coe: c2}) do
        e1 > e2 or (e1 == e2 and c1 > c2)
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

