defmodule Scraper do
  @moduledoc """
  Documentation for `Scraper`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Scraper.hello()
      :world

  """
  def work do
    1..5
    |> Enum.random()
    |> :timer.seconds()
    |> Process.sleep()
  end

  def online?(_url) do
    work()
    Enum.random([false,true,true])
  end

end
