# frozen_string_literal: true

module Metrics
  class Work < Metrics::Collection
    attr_writer :file_size

    def file_size
      @file_size ||= 50
    end

    private

      def work_resource(count)
        resource_params = work_params(count)
        resource_params[:file] = build_temp_file
        build_resource(
          change_set: ::Work::SubmissionChangeSet.new(::Work::Submission.new),
          resource_params: resource_params
        )
      end

      # @todo Creating {Rake::Test::UploadedFile} deletes the original {Tempfile} so it must be recreated
      #   each time. Perhaps there's a way we can avoid that an reuse the same random data each time.
      def build_temp_file
        file = Tempfile.new(i18n_key)
        File.open(file.path, 'wb') do |f|
          file_size.to_i.times { f.write(SecureRandom.random_bytes(1024 * 1024)) }
        end
        ActionDispatch::Http::UploadedFile.new(
          tempfile: file,
          filename: File.basename(Faker::File.file_name)
        )
      end
  end
end
