defmodule Stone.Operations.Implementation do
  @moduledoc false

  alias Stone.MacroHelpers
  alias Stone.Arguments

  def define_starter(definition, options \\ []) do
    {name, args} = Macro.decompose_call(definition)
    payload = args |> Arguments.clear_default_arguments |> Arguments.pack_values_as_tuple

    function_head_clause = {:defstart, name, length(args)}
    gen_server_fun = determine_gen_server_starter_fun(name, options)

    init_ast = if options[:do] do
      define_init(payload, options[:do])
    end

    quote do
      if not (unquote(Macro.escape(function_head_clause)) in @ps_function_heads) do
        def unquote(name)(unquote_splicing(args)) do
          GenServer.unquote(gen_server_fun)(__MODULE__, unquote(payload))
        end
        @ps_function_heads unquote(Macro.escape(function_head_clause))
      end

      unquote(init_ast)
    end
  end

  # Private function that actually defines init
  def define_init(arg, body) do
    quote do
      def init(unquote(arg)), do: unquote(body)
    end
  end

  def define_handler(type, definition, options \\ []) do
    {name, args} = Macro.decompose_call(definition)
    payload = [name | args] |> Arguments.clear_default_arguments |> Arguments.pack_values_as_tuple

    {handler_name, handler_args} = handler_sig(type, options, payload)
    server_fun_name = server_fun_atom(type)

    function_head_clause = {type, name, length(args)}

    generic_function_ast = quote do
      if not (unquote(Macro.escape(function_head_clause)) in @ps_function_heads) do
        def unquote(name)(pid, unquote_splicing(args)) do
          GenServer.unquote(server_fun_name)(pid, unquote(payload))
        end
        @ps_function_heads unquote(Macro.escape(function_head_clause))
      end
    end

    specific_function_ast = if options[:do] do
      quote do
        def unquote(handler_name)(unquote_splicing(handler_args)) do
          unquote(options[:do])
        end
      end
    end

    MacroHelpers.block_helper([
      generic_function_ast,
      specific_function_ast
    ])
  end

  defp server_fun_atom(:defcall), do: :call
  defp server_fun_atom(:defcast), do: :cast

  defp get_state_identifier({:ok, match}), do: quote(do: unquote(match) = unquote(Stone.MacroHelpers.state_var))
  defp get_state_identifier(:error), do: get_state_identifier({:ok, quote(do: _)})

  defp handler_sig(:defcall, options, msg) do
    state_arg = get_state_identifier(Keyword.fetch(options, :state))
    {:handle_call, [msg, options[:from] || quote(do: _from), state_arg]}
  end
  defp handler_sig(:defcast, options, msg) do
    state_arg = get_state_identifier(Keyword.fetch(options, :state))
    {:handle_cast, [msg, state_arg]}
  end
  defp handler_sig(:definfo, options, msg) do
    state_arg = get_state_identifier(Keyword.fetch(options, :state))
    {:handle_info, [msg, state_arg]}
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
          raise "Function name must be either 'start' or 'start_link'. If you need another name, provide explicit :link option."
        end
    end
  end

  # @doc false
  # def extract_args(args) do
  #   arg_names = for {arg, index} <- Enum.with_index(args), do: extract_arg(arg, index)

  #   interface_matches = for {arg, arg_name} <- Enum.zip(args, arg_names) do
  #     case arg do
  #       {:\\, context, [match, default]} -> {:\\, context, [quote(do: unquote(match) = unquote(arg_name)), default]}
  #       match -> quote(do: unquote(match) = unquote(arg_name))
  #     end
  #   end

  #   args = for arg <- args do
  #     case arg do
  #       {:\\, _, [match, _]} -> match
  #       _ -> arg
  #     end
  #   end
  #   {arg_names, interface_matches, args}
  # end

  # defmacrop var_name?(arg_name) do
  #   quote do
  #     is_atom(unquote(arg_name)) and not (unquote(arg_name) in [:_, :\\, :=, :%, :%{}, :{}, :<<>>])
  #   end
  # end

  # # Extract arguments
  # defp extract_arg({:\\, _, [inner_arg, _]}, index), do: extract_arg(inner_arg, index)
  # defp extract_arg({:=, _, [{arg_name, _, _} = arg, _]}, _index) when var_name?(arg_name), do: arg
  # defp extract_arg({:=, _, [_, {arg_name, _, _} = arg]}, _index) when var_name?(arg_name), do: arg
  # defp extract_arg({:=, _, [_, {:=, _, _} = submatch]}, index), do: extract_arg(submatch, index)
  # defp extract_arg({arg_name, _, _} = arg, _index) when var_name?(arg_name), do: arg
  # defp extract_arg(_, index), do: Macro.var(:"arg#{index}", __MODULE__)

  # @doc false
  # def start_args(args) do
  #   {arg_names, interface_matches, args} = extract_args(args)

  #   {payload, match_pattern} =
  #     case args do
  #       [] -> {nil, nil}
  #       [_|_] ->
  #         {
  #           quote(do: {unquote_splicing(arg_names)}),
  #           quote(do: {unquote_splicing(args)})
  #         }
  #     end

  #   {interface_matches, payload, match_pattern}
  # end
end
