defmodule Stone.Operations.Implementation do
  @moduledoc false

  alias Stone.MacroHelpers
  alias Stone.Arguments
  alias Stone.Declaration

  # Guard Function Registration:
  # Make sure that function with given type(a symbol) name and arity
  # Is being defined only once
  #
  # This is guarded by using @stone_function_heads module attribute
  defp guard_function_registration(type, name, args, [do: body]) do
    function_head_clause = {type, name, length(args)}

    quote [bind_quoted: [function_head_clause: Macro.escape(function_head_clause)], unquote: true] do
      if not (function_head_clause in @stone_function_heads) do
        @stone_function_heads function_head_clause

        def unquote(name)(unquote_splicing(args)) do
          unquote(body)
        end
      end
    end
  end

  # Define both spawning function and init/1 handler
  def define_starter(%Declaration{name: name, args: args}, options \\ []) do
    payload = args |> Arguments.clear_default_arguments |> Arguments.pack_values_as_tuple
    gen_server_fun = determine_gen_server_starter_fun(name, options)

    singleton_options = if options[:singleton] do
      [name: options[:singleton]]
    else
      []
    end

    generic_ast = guard_function_registration(:defstart, name, args) do
      quote do
        GenServer.unquote(gen_server_fun)(__MODULE__, unquote(payload), unquote(singleton_options))
      end
    end

    handler_ast = if options[:do] do
      define_init(payload, [do: options[:do]])
    end

    MacroHelpers.block_helper([
      generic_ast,
      handler_ast
    ])
  end

  # Function that actually defines init/1 handler
  def define_init(arg, options \\ []) do
    if options[:do] do
      quote do
        def init(unquote(arg)), do: unquote(options[:do])
      end
    else
      quote do
        def init(unquote(arg))
      end
    end
  end

  def define_handler(type, %Declaration{name: name, args: args}, module, options \\ []) do
    server_fun_name = server_fun_atom(type)
    pid_variable = Macro.var(:pid, module)
    payload = [name | args] |> Arguments.clear_default_arguments |> Arguments.pack_values_as_tuple

    {handler_name, handler_args} = handler_sig(type, options, payload)

    generic_function_ast = if options[:singleton] do
      guard_function_registration(type, name, args) do
        quote do
          GenServer.unquote(server_fun_name)(unquote(options[:singleton]), unquote(payload))
        end
      end
    else
      guard_function_registration(type, name, [pid_variable | args]) do
        quote do
          GenServer.unquote(server_fun_name)(unquote(pid_variable), unquote(payload))
        end
      end
    end

    handler_function_ast = if options[:do] do
      quote do
        def unquote(handler_name)(unquote_splicing(handler_args)) do
          unquote(options[:do])
        end
      end
    end

    MacroHelpers.block_helper([
      generic_function_ast,
      handler_function_ast
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
end
