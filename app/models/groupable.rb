module Groupable
  def grouped(method=:groupable_by, &block)
    grouper = block_given? ? block : method
    self.all.group_by &grouper
  end
end
