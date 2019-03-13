# frozen_string_literal: true

class FileFactory
  attr_reader :use

  def initialize(use: nil)
    @use = use || Valkyrie::Vocab::PCDMUse.PreservationMasterFile
  end

  def hello_world
    temp_file = Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', 'hello_world.txt'))
    file = Work::File.new(original_filename: temp_file.original_filename, use: use)
    file_change_set = Work::FileChangeSet.new(file)
    result = Transaction::Operations::File::Create.new.call(file_change_set, temp_file: temp_file)
    raise result.failure if result.failure?
    result
  end
end
