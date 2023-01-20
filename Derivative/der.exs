defmodule Derivative do

  @type literal() ::  {:number, number()}
                    | {:variable, atom()}
  @type expression() :: {:add, expression(), expression()}
                      | {:multi, expression(), expression()}
                      | {:exponent, literal(), {:number, number()}}
                      | literal()
  @spec deriv(expression(), atom()) :: expression()
  # {:number, 5} = 5
  # {:variable, x} = x
  # {:add, {:number, 5}, {:variable, x} }   = 5+x
  # {:multi, {:number, 5}, {:variable, x} } = 5x
  # {:exponent, {:variable, x}, {:number, 5} } = x^5

  # Function #
  def run() do
    t= {:add,
            {:multi,{:number, 4}, {:variable, :x}},
            {:add, {:multi, {:number, 4}, {:variable, :x}}, {:multi, {:number, 7}, {:variable, :x}}}
       }
    fixed_t = syntax_fix(t)
    result = deriv(t, :x)
    fixed_result = syntax_fix(result)
    IO.inspect(t)
    IO.write("f = #{print(t)}\n")
    IO.write("syntax fix of f = #{print(fixed_t)}\n")
    IO.inspect(result)
    IO.write("f' = #{print(result)}\n")
    IO.write("syntax fix of f' = #{print(fixed_result)}\n")
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

  # Changes the expressions to strings.
  def print({:number, n}),              do: "#{n}"
  def print({:variable, v}),            do: "#{v}"
  def print({:add, expr1, expr2}),      do: "#{print(expr1)}+#{print(expr2)}"
  def print({:multi, expr1, expr2}),    do: "#{print(expr1)}*#{print(expr2)}"
 # def print({:multi, {:number, n}, {:variable, v}}),    do: "#{print(n)}#{print(v)}"
 # def print({:multi, {:variable, v}, {:number, n}}),    do: "#{print(n)}#{print(v)}"
  def print({:exponent, expr1, expr2}), do: "(#{print(expr1)})^#{print(expr2)}"



  # Changes/simplifies the syntax of the expressions
  def syntax_fix({:number, n}),         do: {:number, n}
  def syntax_fix({:variable, v}),       do: {:variable, v}

  def syntax_fix({:add, expr1, expr2}) do
    syntax_fix_add(syntax_fix(expr1), syntax_fix(expr2))
  end

  def syntax_fix({:multi, expr1, expr2})do
    syntax_fix_multi(syntax_fix(expr1), syntax_fix(expr2))
  end

  def syntax_fix_add({:number, 0}, expr),              do: expr
  def syntax_fix_add(expr, {:number, 0}),              do: expr
  def syntax_fix_add({:number, n1}, {:number, n2}),    do: {:number, n1+n2}
  def syntax_fix_add({:variable, v,}, {:variable, v}), do: {:multi, {:number, 2}, {:variable, v}}
  def syntax_fix_add({:variable, v}, {:number, n}),    do: {:add, {:variable, v}, {:number, n},}
  def syntax_fix_add({:multi, {:number, n1}, {:variable, v}}, {:multi, {:number, n2}, {:variable, v}}), do: {:multi, {:number, n1+n2}, {:variable, v}}
  def syntax_fix_add(expr1, expr2),                    do: {:add, expr1, expr2}

  def syntax_fix_multi({:number, n1}, {:number, n2}),  do: {:number, n1*n2}
  def syntax_fix_multi({:number, 0}, _),               do: {:number, 0}
  def syntax_fix_multi(_, {:number, 0}),               do: {:number, 0}
  def syntax_fix_multi(expr1, expr2),                  do: {:multi, expr1, expr2}

end
