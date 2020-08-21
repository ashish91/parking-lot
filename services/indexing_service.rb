class IndexingService

  def initialize
    @slot_by_registration_index = {}
    @cars_slots_by_color_index = {}
  end

  def get_val_by_color(attr, color)
    if @cars_slots_by_color_index.key?(color) && @cars_slots_by_color_index[color].key?(attr)
      @cars_slots_by_color_index[color][attr].keys
    else
      []
    end
  end

  def get_slot_by_registration(registration_no)
    @slot_by_registration_index[registration_no]
  end

  def add_val_to_color_index(attr, color, value)
    @cars_slots_by_color_index[color] ||= {}

    @cars_slots_by_color_index[color][attr] ||= {}
    @cars_slots_by_color_index[color][attr][value] = true
  end

  def del_val_from_color_index(attr, color, value)
    if @cars_slots_by_color_index.key?(color)
      if @cars_slots_by_color_index[color][attr]
        @cars_slots_by_color_index[color][attr].delete(value)
      end
    end
  end

  def add_slot_by_registration_index(slot, registration_no)
    @slot_by_registration_index[registration_no] = slot
  end

  def del_slot_by_registration_index(registration_no)
    @slot_by_registration_index.delete(registration_no)
  end

  def reset_indexes!
    @slot_by_registration_index = {}
    @cars_slots_by_color_index = {}
  end

end
