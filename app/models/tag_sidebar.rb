# frozen_string_literal: true

class TagSidebar < Sidebar
  display_name "Tags"
  description "Show most popular tags for this blog"

  setting :maximum_tags, 20

  def tags
    @tags ||= Tag.find_all_with_content_counters
      .take(maximum_tags.to_i).sort_by(&:name)
  end

  def sizes
    return @sizes if @sizes

    total = tags.reduce(0) { |sum, tag| sum + tag.content_counter }
    average = total.to_f / @tags.size
    @sizes = tags.reduce({}) do |h, tag|
      size = tag.content_counter.to_f / average
      h.merge tag => bucket(size)
    end
  end

  BUCKETS = [
    67,
    75,
    83,
    91,
    100,
    112,
    125,
    137,
    150,
    162,
    175,
    187,
    200
  ].freeze

  private

  def bucket(size)
    base_size = size.clamp(2.0 / 3.0, 2) * 100
    BUCKETS.each do |sz|
      return sz if sz >= base_size
    end
    BUCKETS.last
  end
end

SidebarRegistry.register_sidebar TagSidebar
