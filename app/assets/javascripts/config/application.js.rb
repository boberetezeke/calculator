
class ObjectToUpdate
  attr_reader :action, :object, :state
  def initialize(action, object, state)
    @action = action
    @object = object
    @state = state
  end
end

class Updater
  # scenarios
  #
  # 1 - update_object(1), update_object(1)
  #    replace first with second 
  # 2 - update_object(1, saving), update_object(1)
  #    finish save of first and then save object
  # 3 - insert_object(t-1), update_object(t-1)
  #    update contents of insert with update
  # 4 - insert object(t-1,saving), update_object(t-1)
  #    finish save, update id's in list and stored objects with new id
  # 5 - update_object(1), delete_object(1)
  #    replace update with delete
  # 6 - insert_object(1), delete_object(1)
  #    remove both
  # 7 - update_object(1, saving), delete_object(1)
  #    leave in list
  #
  # NOTE: on delete, what about references to objects?
  # NOTE: how to do cascading delete
  def initialize(application)
    @application = application
    @object_queue = []
  end

  def on_change(action, object)
    object_to_update = ObjectToUpdate.new(action, record, :idle)

    objects_queued_to_update = @object_queue.select{|ots| ots.object.id == object.id}
    if objects_queued_to_update.empty?
      @object_queue.push(object_to_update)
    else
      first_in_queue = objects_queue_to_update.first

      # UPDATE
      if object_to_update.action == :update
        on_update_action(object_to_update)

      # INSERT
      elsif object_to_save.action == :insert

      # DELETE
      else
        on_delete_action(object_to_update, first_in_queue)
      end
    end

    process_queue
  end

  def process_queue
    return if @object_queue.empty? || @object_queue.first.state != :idle

    object_to_update = @object_queue.first
    object_to_update.state = :updating
    object = object_to_update.object
   
    root_url = application.url_for_object(object)
    root_url_with_id = "#{root_url}/#{object_to_update.object.id}"

    case first_in_queue.action 
    when :insert
      HTTP.post(root_url, object.attributes) { |response| handle_response(response) }
    when :update
      HTTP.put(root_url_with_id, object.attributes) { |response| handle_response(response) }
    when :delete
      HTTP.delete(root_url_with_id) { |response| handle_response(response) }
    end
  end

  def handle_response(response)
    if response.ok?
      @object_queue.shift
    else
      object_to_update = @object_queue.first
      object_to_update.retry_count += 1
      if object_to_update.retry_count >= @max_retries
        @application.retry_count_hit
      else
        process_queue
      end
    end
  end

  def on_insert_action(object_to_update, first_in_queue)
    # there shouldn't be anything in here
    raise "insert with objects already found in queue: #{objects_queued_to_save}"
  end

  def on_update_action(object_to_update, first_in_queue)
    if first_in_queue.action == :update || first_in_queue.action == :insert
      if first_in_queue.state == :idle
        # replace it
        first_in_queue.object = object
      else
        # queue it
        @object_queue.push(object_to_update)
      end
    else
      # throw it away
    end
  end

  def on_delete_action(object_to_update, first_in_queue)
    if first_in_queue.action == :insert || first_in_queue.action == :update
      if first_in_queue.state == :idle
        # remove it from the queue
        @object_queue.delete_if do |otu| 
          otu.object.id == object.id && 
          (otu.action == :insert || otu.action == :delete)
        end
      else
        # queue it
        @object_queue.push(object_to_update)
      end
    # its a DELETE
    else
      # there shouldn't be anything in here
      raise "delete with delete objects already found in queue: #{objects_queued_to_save}"
    end
  end
end


class CalculatorApplication < Application
  def initialize
    super

    @store.init_new_table("calculators")
    @store.init_new_table("results")

    @store.on_change do |action, record|
      puts "CalculatorsApplication: action: #{action}, record: #{record}"
      case action
      when :update
      when :insert
      when :delete
      end
    end
  end

  def get_store
    ActiveRecord::LocalStorageStore.new(LocalStorage.new)
  end

  def retry_count_hit
    # go into offline mode
  end

  def url_for_object(object)
    if object.class == Calculator
      return "/calculators"
    else
      return "/results"
    end
  end
end


CalculatorApplication.routes.draw do |router|
  router.resources :calculators
  router.resources :results
end


