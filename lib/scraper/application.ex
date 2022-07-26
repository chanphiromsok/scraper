defmodule Scraper.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      PageProducer,
      PageConsumerSupervisor,
      OnlinePageProducerConsumer
    ]

    # producer always have to start before consumer,
    # if we don't do that,the consumer won't be able subscribe to them because
    # the producer process would not be available

    # Here we are introducing another type of child specification.
    # This format is the shortest, and is equivalent to this:​ 
    # children = [​ {PageProducer, []},​ {PageConsumer, []}​ ]

    opts = [strategy: :one_for_one, name: Scraper.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def producer_consumer_spec(id: id) do
    id = "online_page_producer_consumer_#{id}"
    Supervisor.child_spec({OnlinePageProducerConsumer, id}, id: id)
  end
end
