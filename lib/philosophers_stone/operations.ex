defmodule PhilosophersStone.Operations do
  alias PhilosophersStone.MacroHelpers
  alias PhilosophersStone.Operations

  @doc """
  Define server starting function(`start`, `start_link`) together with corresponding `init/1`.
  """
  defmacro defstart(definition, opts \\ []) do
    {name, args} = Macro.decompose_call(definition)
    {interface_matches, payload, match_pattern} = Operations.start_args(args)

    starter_ast = define_starter(name, interface_matches, payload, opts)

    init_ast = if opts[:do] do
      do_definit(match_pattern, opts[:do])
    end

    MacroHelpers.block_helper([starter_ast, init_ast])
  end

  @doc """
  Define server `init/1` function only with parameters packed as a tuple.
  """
  defmacro definit(arg \\ quote(do: _), opts), do: do_definit(arg, opts[:do])

  # Private function that actually defines init
  defp do_definit(arg, body) do
    quote do
    # quote bind_quoted: [arg: Macro.escape(arg, unquote: true), body: Macro.escape(body, unquote: true)] do
      def init(unquote_splicing([arg])), do: unquote(body)
    end
  end


  # Returns the AST of the starter function
  defp define_starter(name, interface_matches, payload, options) do
    gen_server_fun = determine_gen_server_starter_fun(name, options)

    quote do
      def unquote(name)(unquote_splicing(interface_matches)) do
        GenServer.unquote(gen_server_fun)(__MODULE__, unquote(payload))
      end
    end
  end

  # Determine whether GenServer starter fun called should be `start` or `start_link`
  defp determine_gen_server_starter_fun(name, options) do
    case options[:link] do
      true -> :start_link
      false -> :start
      nil ->
        if name in [:start, :start_link] do
          name
        else
          raise "Function name must be either start or start_link. If you need another name, provide explicit :link option."
        end
    end
  end

  @doc false
  def extract_args(args) do
    arg_names = for {arg, index} <- Enum.with_index(args), do: extract_arg(arg, index)

    interface_matches = for {arg, arg_name} <- Enum.zip(args, arg_names) do
      case arg do
        {:\\, context, [match, default]} -> {:\\, context, [quote(do: unquote(match) = unquote(arg_name)), default]}
        match -> quote(do: unquote(match) = unquote(arg_name))
      end
    end

    args = for arg <- args do
      case arg do
        {:\\, _, [match, _]} -> match
        _ -> arg
      end
    end
    {arg_names, interface_matches, args}
  end

  defmacrop var_name?(arg_name) do
    quote do
      is_atom(unquote(arg_name)) and not (unquote(arg_name) in [:_, :\\, :=, :%, :%{}, :{}, :<<>>])
    end
  end

  # Extract arguments
  defp extract_arg({:\\, _, [inner_arg, _]}, index), do: extract_arg(inner_arg, index)
  defp extract_arg({:=, _, [{arg_name, _, _} = arg, _]}, _index) when var_name?(arg_name), do: arg
  defp extract_arg({:=, _, [_, {arg_name, _, _} = arg]}, _index) when var_name?(arg_name), do: arg
  defp extract_arg({:=, _, [_, {:=, _, _} = submatch]}, index), do: extract_arg(submatch, index)
  defp extract_arg({arg_name, _, _} = arg, _index) when var_name?(arg_name), do: arg
  defp extract_arg(_, index), do: Macro.var(:"arg#{index}", __MODULE__)

  @doc false
  def start_args(args) do
    {arg_names, interface_matches, args} = extract_args(args)

    {payload, match_pattern} =
      case args do
        [] -> {nil, nil}
        [_|_] ->
          {
            quote(do: {unquote_splicing(arg_names)}),
            quote(do: {unquote_splicing(args)})
          }
      end

    {interface_matches, payload, match_pattern}
  end
end
