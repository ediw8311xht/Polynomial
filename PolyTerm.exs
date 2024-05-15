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

    def new(c = %Fraction{}, v, e) do
        #%PolyTerm{coe: c, var: v, exp: e}
        if e == 0 do
            %PolyTerm{coe: c, var: "", exp: e}
        else
            %PolyTerm{coe: c, var: v, exp: e}
        end
    end
    def new(c, v, e) when is_number(c), do: PolyTerm.new(Fraction.new(c), v, e)
    def new(c, v),                      do: PolyTerm.new(c, v, @def_exp)
    def new(s) when is_binary(s) do
        %{"coe" => c, "frac" => f, "var" => v, "exp" => e} = Regex.named_captures(@group_regex, s)
        a = [Fraction.new(Helper.toint(c), f), v, (if v == "", do: 0, else: Helper.toint(e))]
        Kernel.apply(PolyTerm, :new, a)
    end

    def degree(%PolyTerm{exp: e}), do: e

    def value(polyterm, var), do: Fraction.to_float(polyterm.coe) * (var ** polyterm.exp)

    def compare(%PolyTerm{exp: e1, coe: c1}, %PolyTerm{exp: e2, coe: c2}) do
        t1 = Fraction.sign(c1) * e1
        t2 = Fraction.sign(c2) * e2
        cond do
            t1 >  t2    -> :gt
            t1 <  t2    -> :lt
            t1 == t2    -> Fraction.compare(c1, c2)
        end
    end

    def add(%PolyTerm{var: v1, exp: e1}, %PolyTerm{var: v2, exp: e2}) when v1 != v2 or e1 != e2, do: :nil
    def add(%PolyTerm{coe: c1, var: v1, exp: e1}, %PolyTerm{coe: c2, exp: _e2}) do
        sum = Fraction.add(c1, c2)
        if Fraction.not_zero(sum) do
            PolyTerm.new(Fraction.add(c1, c2), v1, e1)
        else
            PolyTerm.new(0, "", 0)
        end
    end


    def divide(%PolyTerm{coe: c1, var: v1, exp: e1}, %PolyTerm{coe: c2, var: v2, exp: e2}) do
        if v1 != v2 and (v1 != "" and v2 != "") do
            :nil
        else
            PolyTerm.new(Fraction.divide(c1, c2), max(v1, v2), e1 - e2)
        end
    end

    def multiply(%PolyTerm{coe: c1, var: v1, exp: e1}, %PolyTerm{coe: c2, var: v2, exp: e2}) do
        if v1 != v2 and (v1 != "" and v2 != "") do
            :nil
        else
            PolyTerm.new(Fraction.multiply(c1, c2), max(v1, v2), e1 + e2)
        end
    end
    def not_zero(%PolyTerm{coe: c1}), do: Fraction.not_zero(c1)
end

defimpl String.Chars, for: PolyTerm do
    def to_string(poly) do
        c = if Fraction.to_float(poly.coe) == 1, do: "", else: String.Chars.to_string(poly.coe)
        v = if poly.exp == 0, do: "", else: poly.var
        e = if poly.exp == 1 or poly.exp == 0, do: "", else: "^" <> String.Chars.to_string(poly.exp)
        c <> v <> e
    end
end

#PolyTerm.new("3/5x^2")
#|>IO.inspect()
