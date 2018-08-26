use Mix.Config
defmodule Blitzy.CLI do
    require Logger

    def main(args) do
        args
        |> parse_args
        |> process_options
    end

    defp parse_args(args) do
        OptionParser.parse(args, aliases: [n: :requests],
                                 strict:  [requests: :integer])
    end

    defp process_options(options, nodes) do
        case options do
            {[requsts: n], [url], []} ->
                # perform action
            _ ->
                do_help
        end
    end

    defp do_help do
        IO.puts """
        Usage:
        blitzy -n [requests] [url]
        Options:
        -n, [--requests]
        # Number of requests
        Example:
        ./blitzy -n 100 http://www.bieberfever.com
        """
        System.halt(0)
    end

end
