defmodule Evaluation do
  @moduledoc """
  Practicing the concepts of lambda calculus through evaluating mathematical
  expressions containing variables.
  """
  @type literal() :: {:number, number()}
                   | {:variable, atom()}
                   | {:ratio, number(), number()} #numerator, denominator

  @type expression() :: {:add, expression(), expression()}
                   | {:subtract, expression(), expression()}
                   | {:multiply, expression(), expression()}
                   | {:divide, expression(), expression()}
                   | literal()
  # For example 2x + 3 + 7/2 <->
  # {:add, {:add, {:multiply, {:number, 2}, {:variable, :x}}, {:number, 3}}, {:ratio, {:number, 1}, {:number, 2}}}

  @doc """
  Takes an expression and an environment, evaluating it and returning a literal.
  """
    def run() do
      #exp = createExprOne()
      #exp = createExprTwo()
      #exp = createExprThree()
      #exp = createExprFour()
      exp = {:sub, {:num, 10}, {:div, {:num, 9}, {:num, 4}}}
      #3 10 - 3/9 == 10 - 1/3
      env = createEnv()
      afterEval = evaluate(exp, env)
      simplified = simplifyDataStructure(afterEval)
      IO.write "##########################################\n"
      IO.write "Expression:\n"
      IO.inspect(exp)
      IO.write "\nEvaluation:\n"
      IO.inspect(afterEval)
      IO.write "\nSimplified:\n"
      IO.inspect(simplified)
      IO.write "\nPrinted:\n"
      IO.write"#{print(simplified)}\n"



    end

    def createExprOne() do
      ## x=10
      ## 2x+5+1
      ## = 26
      {:add, {:add, {:multi, {:num, 2}, {:var, :x}}, {:num, 5}}, {:num, 1}}
    end
    def createExprTwo() do
      ## c=3
      ## 5+2c+3
      ## = 14
      {:add, {:add, {:num, 5}, {:multi, {:num, 2}, {:var, :c}}}, {:num, 3}}
    end
    def createExprThree() do
      ## 5 + 7/3 = 7 + 1/3
      {:add, {:num, 5}, {:div, {:num, 7}, {:num, 3}}}
    end

    def createExprFour() do
      ## 2 * 3/2 = 2* (1 + 1/2) = 3
      {:multi, {:num, 2}, {:div, {:num, 3}, {:num, 2}}}
    end

    def createExprFive() do
      ## 2/4 + 3*b (b=2) => 1/2 + 6
      {:add, {:div, {:num, 2}, {:num, 4}}, {:multi, {:num, 3}, {:var, :b}}}
    end

    def createEnv() do
      env = EnvList2.new()
      env = EnvList2.add(env, :a, 1)
      env = EnvList2.add(env, :b, 2)
      env = EnvList2.add(env, :c, 3)
      env = EnvList2.add(env, :d, 4)
      env = EnvList2.add(env, :x, 10)
      env = EnvList2.add(env, :y, 15)
      env
    end

    def evaluate({:num, n}, _) do {:num, n} end
    def evaluate({:var, v}, enviroment) do
      case EnvList2.lookup(enviroment, v) do
      :nil -> :nil
      {_, n} -> {:num, n}
      end
    end
    def evaluate({:add, {:num, n1}, {:num, n2}}, enviroment), do: {:num, n1+n2}
    def evaluate({:multi, {:num, n1}, {:num, n2}}, enviroment), do: {:num, n1*n2}
    def evaluate({:sub, {:num, n1}, {:num, n2}}, enviroment), do: {:num, n1-n2}
    def evaluate({:multi, expr1, expr2}, enviroment) do
      {:multi, evaluate(expr1, enviroment),evaluate(expr2, enviroment)}
    end

    def evaluate({:add, expr1, expr2}, enviroment) do
      {:add, evaluate(expr1, enviroment),evaluate(expr2, enviroment)}
    end

    def evaluate({:sub, expr1, expr2}, enviroment) do
      {:sub, evaluate(expr1, enviroment),evaluate(expr2, enviroment)}
    end

    def evaluate({:div, expr1, expr2}, enviroment) do
      {:num, n1} = evaluate(expr1, enviroment)
      {:num, n2} = evaluate(expr2, enviroment)
      getRatioDataStructure(n1, n2)
    end

    def evaluate({:ratio, expr1, expr2}, enviroment) do
      {:num, n1} = evaluate(expr1, enviroment)
      {:num, n2} = evaluate(expr2, enviroment)
      getRatioDataStructure(n1, n2)
    end

    def getRatioDataStructure(n1, n2) do
      case rem(n1,n2) do
        0 -> {:num, (round(n1/n2))}
        n when n>0 ->
            if n1>n2 do
              rest = div(n1,n2)
              {:add, {:num, rest}, gcdProtocol(n1-(rest*n2),n2)}
            else
              gcdProtocol(n1,n2)
            end
      end
    end

    def gcdProtocol(n1,n2) do
      gcd = Integer.gcd(n1,n2)
      n1 = round(n1/gcd)
      n2 = round(n2/gcd)
      {:ratio, {:num, n1}, {:num, n2}}
    end

    def simplifyDataStructure({:num, n}), do: {:num, n}
    def simplifyDataStructure({:add, {:num, n1}, {:num, n2}}), do: {:num, n1+n2}
    def simplifyDataStructure({:multi, {:num, n1}, {:num, n2}}), do: {:num, n1*n2}
    def simplifyDataStructure({:sub, {:num, n1}, {:num, n2}}), do: {:num, n1-n2}
    def simplifyDataStructure({:div, expr1, expr2}), do: {:ratio, expr1, expr2}
    def simplifyDataStructure({:ratio, expr1, expr2}), do: {:ratio, expr1, expr2}

    def simplifyDataStructure({:add, expr1, expr2}) do
      simplifyDataStructure_add(simplifyDataStructure(expr1), simplifyDataStructure(expr2))
    end
    def simplifyDataStructure({:multi, expr1, expr2}) do
      simplifyDataStructure_multi(simplifyDataStructure(expr1), simplifyDataStructure(expr2))
    end
    def simplifyDataStructure({:sub, expr1, expr2}) do
      simplifyDataStructure_sub(simplifyDataStructure(expr1), simplifyDataStructure(expr2))
    end

    def simplifyDataStructure_add({:num, n1}, {:num, n2}), do: {:num, n1+n2}
    def simplifyDataStructure_add({:num, n1}, {:ratio, {:num, n2}, {:num, n3}}) do
      {:add, {:num, n1}, {:ratio, {:num, n2}, {:num, n3}}}
    end
    def simplifyDataStructure_add({:ratio, {:num, n2}, {:num, n3}},{:num, n1}) do
      {:add, {:num, n1}, {:ratio, {:num, n2}, {:num, n3}}}
    end
    def simplifyDataStructure_add({:num, n1}, {:add, {:num, n2}, {:ratio, {:num, n3}, {:num, n4}}}) do
      {:add, {:num, n1+n2},{:ratio, {:num, n3}, {:num, n4}}}

    end
    def simplifyDataStructure_multi({:num, n1}, {:num, n2}), do: {:num, n1*n2}
    def simplifyDataStructure_multi({:num, n1}, {:ratio, {:num, n2}, {:num, n3}})do
      getRatioDataStructure(n1*n2, n3)
    end

    def simplifyDataStructure_multi({:ratio, {:num, n1}, {:num, n2}}, {:num, n3})do
      getRatioDataStructure(n1*n3, n2)
    end

    def simplifyDataStructure_multi({:num, n1}, {:add, {:num, n2}, {:ratio, {:num, n3}, {:num, n4}}})do
      simplifyDataStructure({:add, {:num, n1*n2}, getRatioDataStructure(n1*n3,n4)})
    end

    def simplifyDataStructure_multi({:add, {:num, n2}, {:ratio, {:num, n3}, {:num, n4}},{:num, n1}})do
      simplifyDataStructure({:add, {:num, n1*n2}, getRatioDataStructure(n1*n3,n4)})
    end

    def simplifyDataStructure_sub({:num, n1}, {:num, n2}), do: {:num, n1-n2}
    def simplifyDataStructure_sub({:num, n1}, {:ratio, {:num, n2}, {:num, n3}}) do
      {:sub, {:num, n1}, {:ratio, {:num, n2}, {:num, n3}}}
    end
    def simplifyDataStructure_sub({:ratio, {:num, n2}, {:num, n3}},{:num, n1}) do
      {:sub, {:num, n1}, {:ratio, {:num, n2}, {:num, n3}}}
    end
    def simplifyDataStructure_sub({:num, n1}, {:add, {:num, n2}, {:ratio, {:num, n3}, {:num, n4}}}) do
      {:sub, {:num, n1-n2},{:ratio, {:num, n3}, {:num, n4}}}

    end

    def print({:num, n}), do: "#{n}"
    def print({:ratio, n1, n2}), do: "(#{print(n1)}/#{print(n2)})"
    def print({:add, expr1, expr2}), do: "#{print(expr1)} + #{print(expr2)}"
    def print({:sub, expr1, expr2}), do: "#{print(expr1)} - #{print(expr2)}"

end
