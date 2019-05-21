# frozen_string_literal: true

class FileFactory
  attr_reader :use, :text, :original_filename

  def initialize(use: nil, text: nil, original_filename: nil)
    @use = use || Vocab::FileUse.PreservationMasterFile
    @text = text || 'Hello World!'
    @original_filename = original_filename || 'hello_world.txt'
  end

  def build_file_set(attributes:, resource:)
    raise text_file.failure if text_file.failure?

    resource.member_ids = [text_file.success.id]
    fileset = Valkyrie::MetadataAdapter.find(:indexing_persister).persister.save(resource: resource)
    work = attributes.work
    work ||= FactoryBot.build(:work_submission)
    work.member_ids << fileset.id
    Valkyrie::MetadataAdapter.find(:indexing_persister).persister.save(resource: work)
    fileset
  end

  def add_file(resource:)
    raise text_file.failure if text_file.failure?

    # Reload the resource if it's been saved in a previous step
    resource = resource.class.find(resource.id) if resource.persisted?
    resource.member_ids += [text_file.success.id]
    Valkyrie::MetadataAdapter.find(:indexing_persister).persister.save(resource: resource)
  end

  private

    def text_file
      @text_file ||= begin
                       temp_file = temp_text_file(text)
                       file = Work::File.new(original_filename: filename, use: use)
                       file_change_set = Work::FileChangeSet.new(file)
                       Transaction::Operations::File::Create.new.call(file_change_set, temp_file: temp_file)
                     end
    end

    def filename
      use_extention = Repository::FileUse.suffix_from_uri(use)
      return original_filename if original_filename.match?(use_extention)

      path = Pathname.new(original_filename)
      "#{path.basename(path.extname)}_#{use_extention}#{path.extname}"
    end

    def temp_text_file(text)
      file = Tempfile.new
      file.write(text)
      file.close
      file
    end
end
