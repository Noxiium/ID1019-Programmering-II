defmodule Derivative do

  @type literal() ::  {:number, number()}
                    | {:variable, atom()}
  @type expression() :: {:add, expression(), expression()}
                      | {:multi, expression(), expression()}
                      | {:exponent, literal(), {:number, number()}}
                      | {:division, expression(), expression()}
                      | {:ln, expression()}
                      | {:sin, expression()}
                      | {:cos, expression()}
                      | literal()
  @spec deriv(expression(), atom()) :: expression()
  # {:number, 5} = 5
  # {:variable, x} = x
  # {:add, {:number, 5}, {:variable, x} }   = 5+x
  # {:multi, {:number, 5}, {:variable, x} } = 5x
  # {:exponent, {:variable, x}, {:number, 5} } = x^5
  # {:division, {:number, 2}, {:multi, {:number, 5}, {:variable, x}} = 2 / 5x
  # {:ln, {:add, {:number, 5}, {:variable, x} }} = ln(5+x)

  # Function #
  def run() do
    t=  {:cos,
          {:add,
            {:exponent, {:variable, :x}, {:number, 2}},
            {:multi, {:number, 5}, {:variable, :x}}
          }
        }
    result = deriv(t, :x)

    expression_simplified = syntax_fix(t)
    result_simplified = syntax_fix(result)
    IO.write "##########################################\n"
    IO.write("f = #{print(t)}\n")
    IO.write("syntax fix of f = #{print(expression_simplified)}\n")
    IO.write "\n#########################################\n"

    IO.inspect(result_simplified)

    IO.write("\nf' = #{print(result)}\n")
    IO.write("syntax fix of f' = #{print(result_simplified)}\n")
    IO.write "\n#########################################\n"
  end

  # Derivative logic
  def deriv({:number, _}, _),   do: {:number, 0}
  def deriv({:variable, v}, v), do: {:number, 1}
  def deriv({:variable, _}, _), do: {:number, 0}
  def deriv({:add, expr1, expr2}, v) do
    {:add, deriv(expr1, v), deriv(expr2, v)}
  end
  def deriv({:multi, expr1, expr2}, v) do
    {:add, {:multi, deriv(expr1, v), expr2}, {:multi, expr1, deriv(expr2, v)}}
  end

  def deriv({:exponent, {:variable,v}, {:number, n}}, v) do
    {:multi, {:number, n}, {:exponent, {:variable,v}, {:number, n-1}}}
  end

  def deriv({:ln, expr}, v) do
    {:division, deriv(expr, v), expr}
  end

  def deriv({:sin, expr}, v) do
    {:multi, deriv(expr, v), {:cos, expr}}
  end

  def deriv({:cos, expr}, v) do
    {:multi, {:multi, {:number, -1}, deriv(expr, v)}, {:sin, expr}}
  end

  def deriv({:division, nExpr, dExpr}) do
    deriv({:multi, expr1, {:division, {:number, 1}, dExpr}})
  end

  def deriv({:division,})

  def deriv({:division, nExpr, {:variable, v}}), do: deriv({:division, nExpr, {:exponent, {:variable, v}, {:number, 1}}})

  end
  # Changes the expressions to strings.
  def print({:number, n}),              do: "#{n}"
  def print({:variable, v}),            do: "#{v}"
  def print({:add, expr1, expr2}),      do: "#{print(expr1)}+#{print(expr2)}"
  def print({:multi, {:number, n}, {:variable, v}}), do: "#{n}#{v}"
  def print({:multi, expr1, expr2}),    do: "#{print(expr1)}*#{print(expr2)}"
  def print({:exponent, expr1, expr2}), do: "(#{print(expr1)}^#{print(expr2)})"
  def print({:ln, expr}),               do: "ln(#{print(expr)})"
  def print({:division, nExpr, dExpr}), do: "(#{print(nExpr)}) / (#{print(dExpr)})"
  def print({:sin, expr}),              do: "sin(#{print(expr)})"
  def print({:cos, expr}),              do: "cos(#{print(expr)})"




  # Changes/simplifies the syntax of the expressions
  def syntax_fix({:number, n}),         do: {:number, n}
  def syntax_fix({:variable, v}),       do: {:variable, v}
  def syntax_fix({:ln, expr}),          do: {:ln, syntax_fix(expr)}
  def syntax_fix({:sin, expr}),          do: {:sin, syntax_fix(expr)}
  def syntax_fix({:cos, expr}),          do: {:cos, syntax_fix(expr)}
  def syntax_fix({:add, expr1, expr2}) do
    syntax_fix_add(syntax_fix(expr1), syntax_fix(expr2))
  end
  def syntax_fix({:multi, expr1, expr2}) do
    syntax_fix_multi(syntax_fix(expr1), syntax_fix(expr2))
  end
  def syntax_fix({:exponent, expr1, expr2}) do
    syntax_fix_exponent(syntax_fix(expr1), syntax_fix(expr2))
  end
  def syntax_fix({:division, nExpr, dExpr}) do
    syntax_fix_division(syntax_fix(nExpr), syntax_fix(dExpr))
  end



  def syntax_fix_add({:number, 0}, expr),              do: expr
  def syntax_fix_add(expr, {:number, 0}),              do: expr
  def syntax_fix_add({:number, n1}, {:number, n2}),    do: {:number, n1+n2}
  def syntax_fix_add({:variable, v,}, {:variable, v}), do: {:multi, {:number, 2}, {:variable, v}}
  def syntax_fix_add({:variable, v}, {:number, n}),    do: {:add, {:variable, v}, {:number, n},}
  def syntax_fix_add({:multi, {:number, n1}, {:variable, v}}, {:multi, {:number, n2}, {:variable, v}}), do: {:multi, {:number, n1+n2}, {:variable, v}}
  def syntax_fix_add({:multi, {:number, n1}, expr}, {:multi, {:number, n2}, expr}), do: {:multi, {:number, n1+n2}, expr}
  def syntax_fix_add({:number, n1}, {:add, expr, {:number, n2}}), do: {:add, expr, {:number, n1+n2}}
  def syntax_fix_add(expr, expr),                      do: {:multi, {:number, 2}, expr}
  def syntax_fix_add(expr1, expr2),                    do: {:add, expr1, expr2}

  def syntax_fix_multi({:number, n1}, {:number, n2}),  do: {:number, n1*n2}
  def syntax_fix_multi({:number, 0}, _),               do: {:number, 0}
  def syntax_fix_multi(_, {:number, 0}),               do: {:number, 0}
  def syntax_fix_multi({:number, n1}, {:multi, {:number, n2}, expr}), do: {:multi, {:number, n1*n2}, expr}
  def syntax_fix_multi({:number, n0}, {:add, {:multi, {:number, n1}, {:variable, v}}, {:number, n2}}), do: {:add, {:multi, {:number, n0*n1}, {:variable, v}}, {:number, n0*n2}}

  def syntax_fix_multi(expr1, expr2),                  do: {:multi, expr1, expr2}

  def syntax_fix_exponent(expr, {:number, 1}),         do: expr
  def syntax_fix_exponent(expr1, expr2),               do: {:exponent, expr1, expr2}

  def syntax_fix_division(nExpr, dExpr),               do: {:division, nExpr, dExpr}
end
