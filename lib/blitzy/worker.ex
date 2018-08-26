defmodule Blitzy.Worker do
    @moduledoc """
    This module is a worker which do the measurement of servers respond.

    When everything goes OK:
    iex> {:ok, %{status_code: code}
    If not:
    {:error, reason}
    """
    use Timex
    require Logger


    def start(url) do
        {timestamp, response} = Duration.measure(fn -> HTTPoison.get(url) end)
        handle_response({Duration.to_milliseconds(timestamp), response})
    end

    ### work with response

    @doc """
    17:28:01.149 [info]  worker [nonode@nohost-#PID<0.876.0>] completed in 770.104msecs
    """
    defp handle_response({msecs, {:ok, %HTTPoison.Response{status_code: code}}})
        when code >= 200 and code <= 304 do
            Logger.info "worker [#{node}-#{inspect self}] completed in #{msecs}msecs"
            {:ok, msecs}
    end

    @doc """
    17:29:20.046 [info]  worker [nonode@nohost-#PID<0.876.0>] error due to %HTTPoison.Error{id: nil, reason: :nxdomain}
    {:error, %HTTPoison.Error{id: nil, reason: :nxdomain}}
    """
    defp handle_response({_msecs, {:error, reason}}) do
        Logger.info "worker [#{node}-#{inspect self}] error due to #{inspect reason}"
        {:error, reason}
    end

    @doc """
    {:ok, 770.104}
    """
    defp handle_response({_msecs, _}) do
        Logger.info "worker [#{node}-#{inspect self}] errored out"
        {:error,:unknown}
    end

    ### work with response

end
