# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database
# with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the
# db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Daley', city: cities.first)

blog = Blog.first || Blog.create!

unless blog.sidebars.any?
  PageSidebar.create!(active_position: 0, staged_position: 0, blog: blog)
  TagSidebar.create!(active_position: 1, blog: blog)
  ArchivesSidebar.create!(active_position: 2, blog: blog)
  StaticSidebar.create!(active_position: 3, blog: blog)
  MetaSidebar.create!(active_position: 4, blog: blog)
end
