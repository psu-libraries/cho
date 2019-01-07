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
        tempfile = Tempfile.new(i18n_key)
        filename = File.basename(Faker::File.file_name)
        generate_content(tempfile: tempfile, filename: filename)
        ActionDispatch::Http::UploadedFile.new(
          tempfile: tempfile,
          filename: filename
        )
      end

      def generate_content(tempfile:, filename:)
        File.open(tempfile.path, 'wb') do |f|
          if extractable?(filename)
            f.write(Faker::Hipster.paragraph_by_chars(2048, false))
          else
            file_size.to_i.times { f.write(SecureRandom.random_bytes(1024 * 1024)) }
          end
        end
      end

      # @todo duplicated in Work::File
      def extractable?(filename)
        mime_type = MIME::Types.type_for(filename)
        (mime_type.map(&:to_s) & ['application/pdf', 'text/html', 'text/markdown', 'text/plain']).present?
      end
  end
end
