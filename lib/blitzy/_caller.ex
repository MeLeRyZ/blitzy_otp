# defmodule Blitzy.Caller do
    # @moduledoc """
    # Creates an amount of workers to sen GET to one url.
    #
    # iex> Blitzy.Caller.start(50, "google.com")
    #     ...
    # """
#     def start(n_workers, url) do
#         me = self # need to send|receive between caller and worker
#
#         1..n_workers
#         |> Enum.map(fn _ -> spawn(fn -> Blitzy.Worker.start(url, me) end) end)
#         |> Enum.map(fn _ ->
#             receive do
#                 x -> x
#             end
#         end)
#     end
#
# end
