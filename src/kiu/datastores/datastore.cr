require "../jobs"

module Kiu::Datastores
  alias Job = Jobs::Job

  abstract class Datastore
    # Namespace for the datastore.
    #
    # Used to differentiate keys, tables,... used by this store from unrelated ones in a shared resource.
    @namespace : String

    def initialize(@namespace = "kiu")
    end

    private abstract def enqueue(job : Job)

    def enqueue?(job : Job)
      if job.attempts_left > 0
        enqueue job
      end
    end

    def retry(job : Job)
      job.try_once
      job.priority -= 1
      job.due_in job.attempts_made.minutes

      enqueue? job
    end

    abstract def take(n : UInt32) : Array(Job)
  end
end
