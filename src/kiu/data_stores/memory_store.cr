require "priority-queue"
require "./data_store"

module Kiu::DataStores
  alias PriorityQueue = Priority::Queue

  # In-memory data store.
  class MemoryStore < DataStore
  end
end
