module Kiu::Jobs
  abstract class Job
    enum Status
      Draft
      Queued
      Pending
      Performing
      Successful
      SoftFailed
      HardFailed
    end

    getter max_attempts : UInt8
    getter attempts_left : UInt8

    property due_at : Time
    property! expire_at : Time?
    property! interval : Time::Span?

    getter status : Status

    property priority : Int8

    macro serializer(serializable, decode_f, encode_f)
      include {{serializable}}

      def self.decode(value) : {{@type.id}}
        {{@type.id}}.{{decode_f.id}} value
      end

      def encode
        {{encode_f.id}}
      end
    end

    def initialize(
      *,
      @max_attempts = 1_u8,
      @due_at = Time.utc,
      @expire_at = nil,
      @interval = nil
    )
      @attempts_left = @max_attempts
      @status = Status::Draft
      @priority = 0_i8
    end

    def attempts_made
      @max_attempts - @attempts_left
    end

    def try_once
      @attempts_left -= 1
    end

    def reset_attempts
      @attempts_left = @max_attempts
    end

    def due_now
      @due_at = Time.utc
    end

    def due_in(span : Time::Span)
      @due_at = Time.utc + span
    end

    def expire_now
      @expire_at = Time.utc
    end

    def expire_in(span : Time::Span)
      @expire_at = Time.utc + span
    end

    def never_expire
      @expire_at = nil
    end

    # Returns the object itself
    def self.decode(value)
      value
    end

    # Returns the object itself
    def encode
      self
    end
  end
end
