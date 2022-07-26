defmodule PageConsumer do
  use GenStage
  require Logger

  def start_link(event) do
    Logger.info("PageConsumer received #{event}")

    Task.start_link(fn ->
      Scraper.work()
    end)
  end

  def random_job_id do
    :crypto.strong_rand_bytes(5)
    |> Base.url_encode64(padding: false)
  end

  @impl true
  def init(initial_state) do
    selector = fn incoming_event ->
      IO.inspect(incoming_event)
      true
    end

    sub_opts = [
      {PageProducer, min_demand: 0, max_demand: 2, selector: selector}
    ]

    {:consumer, initial_state, subscribe_to: sub_opts}
  end

  @impl true
  def handle_events(events, _from, state) do
    Logger.info("Page Consumer received #{inspect(events)}")

    Enum.each(events, fn _page ->
      Scraper.work()
    end)

    {:noreply, [], state}
  end

  def via(key, value) do
    {:via, Registry, {Scraper.Registry, key, value}}
  end
end

# event to process = max_demand - min_demand
