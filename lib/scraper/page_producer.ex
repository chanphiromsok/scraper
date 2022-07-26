defmodule PageProducer do
  use GenStage
  require Logger

  def start_link(_args) do
    initial_state = []
    GenStage.start_link(__MODULE__, initial_state, name: __MODULE__)
  end

  @impl true
  def init(initial_state) do
    Logger.info("PageProducer Init")
    # {:producer, initial_state, buffer_size: 1}
    {:producer, initial_state}

  end


  @impl true
  def handle_demand(demand, state) do
    Logger.info("PageProducer received demand for #{demand} pages")
    event = []
    {:noreply, event, state}
  end

  def scrape_pages(pages \\ ["google.com","facebook.com","apple.com","netflix.com","amazon.com"]) when is_list(pages) do
    GenStage.cast(__MODULE__, {:pages, pages})
  end

  @impl true
  def handle_cast({:pages, pages}, state) do
    pages= Enum.map(pages,fn p -> p <> "hello" end)
    {:noreply, pages , state}
  end
  # handle_cast broadcast to consumer who subscribe to PageProducer
end

# pages =[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20]
# PageProducer.scrape_pages(pages)
