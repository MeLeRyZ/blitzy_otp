use Mix.Config
defmodule Blitzy.CLI do
    require Logger

    def main(args) do
        Application.get_env(:blitzy, :master_node) # Starts the master node
            |> Node.start                          # in distributed mode

        Application.get_env(:blitzy, :slave_nodes) # Connects to the slave nodes
            |> Enum.each(&Node.connect(&1))

        args
        |> parse_args
        |> process_options([node|Node.list])        # Passes a list of all the nodes in the
    end                                             # cluster into process_options/2

    defp parse_args(args) do
        OptionParser.parse(args, aliases: [n: :requests],
                                 strict:  [requests: :integer])
    end

    defp process_options(options, nodes) do
        case options do
            {[requsts: n], [url], []} ->
                do_requests(n, url, nodes)
            _ ->
                do_help
        end
    end

    defp do_requests(n_requests, url, nodes) do
        Logger.info "Pummeling #{url} with #{n_requests} requests"

        total_nodes = Enum.count(nodes)
        req_per_node = div(n_requests, total_nodes)

        nodes
        |> Enum.flat_map(, (fn node ->
            1..req_per_node |> Enum.map( fn _ ->
                Task.Supervisor.async({Blitzy.TasksSupervisor, node},
                                      Blitzy.Worker,
                                      :start,
                                      [url])
             end)
        end)
        |> Enum.map(&Task.await(&1, :infinity))
        |> parse_results
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
